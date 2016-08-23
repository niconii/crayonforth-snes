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
    bmi linedone
    bne refreshscr  ; TODO: bvs didn't work and I don't know why
    jmp end

linedone:
    jsr refresh_screen

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

.a8
refreshscr:
    jsr refresh_screen

end:
    stz Flags
    rep #$20

    ; Read controllers
    lda #%00000001
:   bit HVBJOY
    bne :-

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


    ply
    plx
    pla
    pld
    plb
    rti
.endproc

.a8
.proc refresh_screen
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
    
    rts
.endproc
.a16