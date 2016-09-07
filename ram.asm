.segment "ZEROPAGE"
Joy1Cur   := $00
Joy1Prs   := $02
Joy2Cur   := $04
Joy2Prs   := $06
Slot0Bank := $08
Slot1Bank := $09
Flags     := $0a
LineLen   := $0b
TextColor := $0c
CursorX   := $0d
CursorY   := $0e
ScrollV   := $0f
VBlankPtr := $10

.segment "BSS"
LineBuffer := $0200