.p816
.a16
.i16
.smart +
.include "consts.inc"
.include "macros.inc"

.include "ram.asm"

.segment "HEADER"
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
    .include "console/output.asm"
    .include "console/fontcolor.asm"
    .include "console/c64.asm"
    .include "misc.asm"
    .include "main.asm"
