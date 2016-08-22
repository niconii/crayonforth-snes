.p816
.smart +
.include "consts.asm"
.include "macros.asm"

.include "header.asm"
.include "ram.asm"

.segment "FONT"
font:
    .incbin "build/gfx/font0+font1.2bpp"

.segment "CODE"
    .include "init.asm"
    .include "vblank.asm"
    .include "output.asm"

empty_handler: rti
zerobyte: .byte $00

.proc start
    sep #$20
        ; Set up palette
        stz CGADD
        font0 BGCOLOR, FTCOLOR0
        font0 BGCOLOR, FTCOLOR1
        font1 BGCOLOR, FTCOLOR0
        font1 BGCOLOR, FTCOLOR1

        ; Set up font
        stz VMADDL
        stz VMADDH
        lda #%00000001      ; a->b astep=+1 unit=[0,1]
        sta DMAP7
        lda #<VMDATAL       ; b=VMDATAL
        sta BBAD7
        ldy #.loword(font)  ; a=font
        sty A1T7L
        lda #^font
        sta A1B7
        ldy #(8*8*256*2/8)  ; len=8*8*256*2/8
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN

        ; Set up BG1
        lda #%00001000      ; attribute table at $0800, 32x32 screen
        sta BG1SC
        lda #%00000001      ; enable BG1 on main screen
        sta TM

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

    ; Set up data stack
    ldx #$0180

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