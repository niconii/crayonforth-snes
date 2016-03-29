.p816
.include "header.asm"

.segment "ROM0"
    .include "init.asm"
    .include "start.asm"

.segment "ROM1"
font:
    .incbin "build/gfx/font.2bpp"
