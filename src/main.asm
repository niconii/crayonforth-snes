.p816
.a16
.i16
.smart +
.include "consts.inc"
.include "macros.inc"

.include "ram.asm"
.include "header.asm"

.segment "FONT"
font:
    .incbin "build/fonts/font0+font1.2bpp"
fonte:
    .incbin "build/fonts/font0+font1.evens.2bpp"
fonto:
    .incbin "build/fonts/font0+font1.odds.2bpp"

.segment "CODE"
    .include "init.asm"
    .include "joypad.asm"
    .include "vblank.asm"
    .include "output.asm"
    .include "fontcolor.asm"
    .include "c64.asm"

empty_handler: rti
zerobyte: .byte $00

.proc start
    ; Set up data stack
    ldx #$0180

    ; Set up 64x28 console
    jsr c64init

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