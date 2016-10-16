; c64init ( -- )
.proc c64init
    ; Disable interrupts
    sei
    pha

    ; Turn off screen, turn off vblank NMIs
    sep #$20
        stz NMITIMEN
        lda #$8f
        sta INIDISP
    rep #$20
    
    ; Set vblank pointer
    lda #(.loword(_c64update) - 1)
    sta VBlankPtr

    ; Set up palette
    dpush #BGCOLOR
    dpush #FTCOLOR0
    dpush #0
    jsr _font0

    dpush #BGCOLOR
    dpush #FTCOLOR1
    dpush #1
    jsr _font0

    dpush #BGCOLOR
    dpush #FTCOLOR0
    dpush #2
    jsr _font1

    dpush #BGCOLOR
    dpush #FTCOLOR1
    dpush #3
    jsr _font1

    sep #$20
        ; Set up variables
        stz ScFlags
        lda #(64*2)
        sta ScreenW
        stz TAttrib
        stz CursorX
        stz CursorY
        stz ScrollV
    rep #$20

    ; Clear line buffer
    jsr clearline

    sep #$20
        ; DMA transfer font even pixels
        ldy #C64FONTEVEN
        sty VMADDL
        lda #%00000001      ; a->b astep=+1 unit=[0,1]
        sta DMAP7
        lda #<VMDATAL       ; b=VMDATAL
        sta BBAD7
        ldy #.loword(fonte) ; a=fonte
        sty A1T7L
        lda #^fonte
        sta A1B7
        ldy #FONTLEN        ; len=FONTLEN
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN
        
        ; Clear screen buffer
        lda #%00001001      ; a->b astep=+0 unit=[0,1]
        sta DMAP7
        ldy #.loword(zerobyte) ; a=zerobyte
        sty A1T7L
        lda #^zerobyte
        sta A1B7
        ldy #(64*32*2)      ; len=64*32*2
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN

        ; DMA transfer font odd pixels
        lda #%00000001      ; a->b astep=+1 unit=[0,1]
        sta DMAP7
        ldy #.loword(fonto) ; a=fonto
        sty A1T7L
        ldy #FONTLEN        ; len=FONTLEN
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN

        ; Set up BGs
        lda #%00001000      ; attribute table at $0800, 32x32 screen
        sta BG1SC
        lda #%00001000      ; attribute table at $0800, 32x32 screen
        sta BG2SC
        lda #%00001100      ; attribute table at $0c00, 32x32 screen
        sta BG3SC
        lda #%00001100      ; attribute table at $0c00, 32x32 screen
        sta BG4SC
        lda #%00010000      ; BG1 font at $0000, BG2 font at $1000
        sta BG12NBA
        lda #%00010000      ; BG3 font at $0000, BG4 font at $1000
        sta BG34NBA
        lda #%00000101      ; enable BG1 + BG3 on subscreen
        sta TS
        lda #%00001010      ; enable BG2 + BG4 on main screen
        sta TM

        lda #%00001000      ; enable pseudo-hires
        sta SETINI

        ; Enable interrupts
        cli

        ; Enable vblank NMI and automatic joypad reading
        lda #%10000001
        sta NMITIMEN

        ; Wait two vblanks to initialize joypads
        wai
        wai

        ; Turn screen on
        lda #$0f
        sta INIDISP
    rep #$20

    pla
    rts
.endproc

; _c64update ( -- ) blanking only
.proc _c64update
    pha

    ; Check flags
    sep #$20
        lda ScFlags
        bit #$40
    rep #$20
    bmi flinedone
    bne frefresh    ; TODO: bvs didn't work and I don't know why
    jmp end

flinedone:
    jsr _c64cr

frefresh:
    jsr _c64refresh

end:
    sep #$20
        stz ScFlags
    rep #$20

    jsr joy

    pla
    rts
.endproc


; _c64cr ( -- ) blanking only
.proc _c64cr
    pha
    phx
    jsr _c64refresh

    sep #$20
        stz CursorX
        lda CursorY
        inc a
        and #(32-1)
        sta CursorY

        ; Scroll if cursor is past the end
        asl a
        asl a
        asl a
        sec
        sbc #224
        cmp ScrollV
        bne :+
            lda ScrollV
            clc
            adc #8
            sta ScrollV
        :
    rep #$20

    jsr clearline

    plx
    pla
.endproc


; _c64refresh ( -- ) blanking only
.proc _c64refresh
    pha
    phx
    sep #$20

    stz BG1HOFS
    stz BG1HOFS
    stz BG2HOFS
    stz BG2HOFS
    lda #(256-4)
    sta BG3HOFS
    stz BG3HOFS
    sta BG4HOFS
    stz BG4HOFS

    lda ScrollV
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
        ldy LineBuf,x
        sty VMDATAL
        inx
        inx
        inx
        inx
    cpx ScreenW
    bne :-

    rep #$20
        pla
        ora #$0c00
        sta VMADDL
    sep #$20

    ldx #0
    :
        ldy LineBuf+2,x
        sty VMDATAL
        inx
        inx
        inx
        inx
    cpx ScreenW
    bne :-
    
    rep #$20
    plx
    pla
    rts
.endproc
