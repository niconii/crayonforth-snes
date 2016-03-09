arch snes.cpu

include "macros.inc"
include "consts.inc"
include "init.inc"

// ensure rom is padded out to 4 MB
seek($ffffff)
db 0

// bank 0
seek($008000)
include "start.asm"
seek($00ffb0)
include "header.asm"

// bank 1
seek($018000)
insert font, "build/gfx/font.2bpp"
