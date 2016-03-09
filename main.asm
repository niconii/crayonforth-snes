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
seekf($00ffb0)
include "header.asm"

// bank 1
seekf($018000)
insert font, "build/gfx/font.2bpp"

// bank 2
seekf($028000)
