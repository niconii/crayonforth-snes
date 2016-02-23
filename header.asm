// ROM HEADER
seek($00ffc0)
  //123456789012345678901
db "TEST ROM             " // cartridge title
seek($00ffd5)
db %00110000 // fast LoROM
db $00 // ROM, no RAM, no battery
db $0c // 4 MB rom
db $00 // no ram
db $00 // international/japan
db $33 // extended header
db $00 // version 1.0
dw $ffff // checksum complement (placeholder)
dw $0000 // checksum (placeholder)

// EXTENDED HEADER
seek($00ffb0)
db "N&" // maker code
db "TEST" // game code
db 0,0,0,0,0,0 // reserved
db $00 // no expansion flash
db $00 // no expansion ram
db $00 // not a special version
db $00 // no custom co-processor

seek($00ffe0)
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw empty_handler
dw reset
dw empty_handler
