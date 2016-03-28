arch snes.cpu

include "macros.inc"
include "consts.inc"

pad_to($ffffff)

start($80)

bank($80)
include "init.asm"
include "start.asm"

seekf($80ffb0)
include "header.asm"

bank($81)
insert font, "build/gfx/font.2bpp"

end()
