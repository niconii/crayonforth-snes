arch snes.cpu

macro seek(variable offset) {
    origin ((offset & $7f0000) >> 1) | (offset & $007fff)
    base offset
}

// ensure rom is padded out to 4 MB
seek($ffffff)
db 0

include "init.asm"
include "io.asm"
include "print.asm"

// bank 0
seek($008000)
include "start.asm"
seek($00ffb0)
include "header.asm"

// bank 1
seek($018000)
insert font, "build/gfx/font.2bpp"
