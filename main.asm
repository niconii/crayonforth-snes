.p816
.smart +
.include "consts.asm"
.include "macros.asm"

.include "header.asm"
.include "ram.asm"

.segment "FONT"
fonte:
    .incbin "build/gfx/font0+font1.evens.2bpp"
fonto:
    .incbin "build/gfx/font0+font1.odds.2bpp"

.segment "CODE"
    .include "init.asm"
    .include "vblank.asm"
    .include "output.asm"

empty_handler: rti
zerobyte: .byte $00

.proc start
    ; Set up data stack
    ldx #$0180

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
        ; DMA font even pixels
        stz VMADDL
        stz VMADDH
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
        
        ldy #$1000
        sty VMADDL
        ldy #.loword(fonto) ; a=fonto
        sty A1T7L
        ldy #FONTLEN
        sty DAS7L
        lda #%10000000
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

main_loop:
    lda Joy1Prs

    bit #BUTTON_B
    beq :+
        dpush #'B'
        jsr emit
    :

    bit #BUTTON_Y
    beq :+
        dpush #'Y'
        jsr emit
    :

    bit #BUTTON_SELECT
    beq :+
        dpush #' '
        jsr emit
    :

    bit #BUTTON_START
    beq :+
        jsr cr
    :

    bit #BUTTON_A
    beq :+
        dpush #'A'
        jsr emit
    :

    bit #BUTTON_X
    beq :+
        dpush #'X'
        jsr emit
    :

    bit #BUTTON_L
    beq :+
        dpush #'L'
        jsr emit
    :

    bit #BUTTON_R
    beq :+
        dpush #'R'
        jsr emit
    :
    
    wai
    bra main_loop
.endproc