include "fontmap_ascii.inc"

header:

// EXTENDED HEADER
db "N&" // maker code
db "TEST" // game code
db 0,0,0,0,0,0 // reserved
db $00 // no expansion flash
db $00 // no expansion ram
db $00 // not a special version
db $00 // no custom co-processor

// ROM HEADER
//  123456789012345678901
db "TEST ROM             " // cartridge title
db %00110000 // fast LoROM
db $00 // ROM, no RAM, no battery
db $0c // 4 MB rom
db $00 // no ram
db $00 // international/japan
db $33 // extended header
db $00 // version 1.0
dw $ffff // checksum complement (placeholder)
dw $0000 // checksum (placeholder)

dw empty_handler
dw empty_handler
dw empty_handler // 65816 COP
dw empty_handler // 65816 BRK
dw empty_handler
dw vblank        // 65816 NMI (VBlank)
dw empty_handler
dw empty_handler // 65816 IRQ (H/V timer)
dw empty_handler
dw empty_handler
dw empty_handler // 6502 COP
dw empty_handler
dw empty_handler
dw empty_handler // 6502 NMI
dw reset         // 6502 RESET
dw empty_handler // 6502 IRQ/BRK

header.end:

if header.end - header != $50 {
    error "Bad header size"
}
