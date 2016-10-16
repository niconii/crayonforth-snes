.segment "ZEROPAGE"
Joy1Cur   := $00
Joy1Prs   := $02
Joy2Cur   := $04
Joy2Prs   := $06
Slot0Bank := $08
Slot1Bank := $09
VBlankPtr := $0a

.segment "BSS"
LineBuf := $0200
ScFlags := $0280
TAttrib := $0281
CursorX := $0282
CursorY := $0283
ScreenW := $0284
ScreenH := $0285

ScrollV := $0288

ColorBg := $028e
Color0  := $0290
Color1  := $0292
Color2  := $0294
Color3  := $0296
Color4  := $0298
Color5  := $029a
Color6  := $029c
Color7  := $029e