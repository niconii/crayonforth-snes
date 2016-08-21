.p816
.smart +
.include "header.asm"

.segment "ROM0"
    .include "init.asm"
    .include "vblank.asm"

start:
    jmp start

empty_handler:
    rti
    
.segment "ROM1"
font:
    .incbin "build/gfx/font.2bpp"
