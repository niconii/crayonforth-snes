.proc vblank
    phb
    phd
    rep #$30
    pha
    phx
    phy

    ; Check flags
    sep #$20
        lda Flags
        bit #$40
    rep #$20
    bmi flinedone
    bne frefresh    ; TODO: bvs didn't work and I don't know why
    jmp end

flinedone:
    jsr _cr

frefresh:
    jsr _refresh

end:
    sep #$20
        stz Flags
    rep #$20

    jsr _joy

    ply
    plx
    pla
    pld
    plb
    rti
.endproc

; _cr ( -- ) blanking only
.proc _cr
    pha
    phx
    jsr _refresh
    sep #$20

    stz CursorX
    lda CursorY
    inc a
    and #(32-1)
    sta CursorY

    ; Scroll screen if cursor has gone past the end
    asl a
    asl a
    asl a
    sec
    sbc #224
    cmp OffsetV
    bne :+
        lda OffsetV
        clc
        adc #8
        sta OffsetV
    :

    ; Zero-fill line buffer with DMA
    ; TODO: figure out why this fails to do anything
;    ldy #LineBuffer
;    sty WMADDL
;    stz WMADDH
;    lda #%00001000      ; a->b astep=+0 unit=[0]
;    sta DMAP7
;    lda #<WMDATA        ; b=WMDATA
;    sta BBAD7
;    ldy #.loword(zerobyte) ; a=zerobyte
;    sty A1T7L
;    lda #^zerobyte
;    sta A1B7
;    ldy #LINELEN        ; len=LINELEN
;    sty DAS7L
;    lda %10000000       ; initiate DMA
;    sta MDMAEN
    ldx #LINELEN
    :
        dex
        stz LineBuffer,x
    bne :-
    
    rep #$20
    plx
    pla
.endproc

; _refresh ( -- ) blanking only
.proc _refresh
    pha
    phx
    sep #$20

    lda OffsetH
    sta BG1HOFS
    stz BG1HOFS
    sta BG2HOFS
    stz BG2HOFS
    sec
    sbc #4
    sta BG3HOFS
    stz BG3HOFS
    sta BG4HOFS
    stz BG4HOFS

    lda OffsetV
    dec a
    sta BG1VOFS
    stz BG1VOFS
    sta BG2VOFS
    stz BG2VOFS
    sta BG3VOFS
    stz BG3VOFS
    sta BG4VOFS
    stz BG4VOFS

    ; Write line buffer to VRAM
    stz VMAIN

    rep #$20
        lda CursorY
        and #$00ff
        asl a
        asl a
        asl a
        asl a
        asl a
        pha
        ora #$0800
        sta VMADDL
    sep #$20

    ldx #0
    :
        ldy LineBuffer,x
        sty VMDATAL
        inx
        inx
        inx
        inx
    cpx #LINELEN
    bne :-

    rep #$20
        pla
        ora #$0c00
        sta VMADDL
    sep #$20

    ldx #0
    :
        ldy LineBuffer+2,x
        sty VMDATAL
        inx
        inx
        inx
        inx
    cpx #LINELEN
    bne :-
    
    rep #$20
    plx
    pla
    rts
.endproc

; _joy ( -- ) blanking only
.proc _joy
    pha
    phx

    sep #$20
        lda #%00000001
        :
            bit HVBJOY
        bne :-
    rep #$20

    ldy JOY1L
    tya
    eor Joy1Cur
    sty Joy1Cur
    and Joy1Cur
    sta Joy1Prs

    ldy JOY2L
    tya
    eor Joy2Cur
    sty Joy2Cur
    and Joy2Cur
    sta Joy2Prs

    plx
    pla
    rts
.endproc

; _color ( c -- ) blanking only
.proc _color
    sep #$20
        sta CGDATA
        xba
        sta CGDATA
    rep #$20
    dpop
    rts
.endproc

; _font0s ( bg fg a -- bg fg a ) blanking only
.proc _font0s
    sep #$20
        sta CGADD
    rep #$20
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    rts
.endproc

; _font0 ( bg fg n -- ) blanking only
.proc _font0
    asl a
    asl a
    jsr _font0s
    clc
    adc #$20
    jsr _font0s
    clc
    adc #$20
    jsr _font0s
    clc
    adc #$20
    jsr _font0s

    ldy $04,x
    txa
    clc
    adc #6
    tax
    tya
    rts
.endproc

; _font1s ( bg fg a -- bg fg a ) blanking only
.proc _font1s
    sep #$20
        sta CGADD
    rep #$20
    dpush {$04,x}
    jsr _color
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    rts
.endproc

; _font1 ( bg fg n -- ) blanking only
.proc _font1
    asl
    asl
    jsr _font1s
    clc
    adc #$20
    jsr _font1s
    clc
    adc #$20
    jsr _font1s
    clc
    adc #$20
    jsr _font1s

    ldy $04,x
    txa
    clc
    adc #6
    tax
    tya
    rts
.endproc
