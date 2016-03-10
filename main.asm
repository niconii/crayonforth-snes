arch snes.cpu

include "macros.inc"
include "consts.inc"
include "init.inc"

pad_to($ffffff)

start()

bank(0)
include "start.asm"
seekf($00ffb0)
include "header.asm"

bank(1)
insert font, "build/gfx/font.2bpp"

end()
