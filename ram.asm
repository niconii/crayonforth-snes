.segment "ZEROPAGE"
Joy1Cur   := $00
Joy1Prs   := $02
Joy2Cur   := $04
Joy2Prs   := $06
Slot0Bank := $08
Slot1Bank := $09
Flags     := $0a
TextColor := $0b
CursorX   := $0c
CursorY   := $0d
OffsetH   := $0e
OffsetV   := $0f

.segment "BSS"
LineBuffer := $0200