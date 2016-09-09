; Extended cartridge header
    .byte "N&"          ; maker code
    .byte "TEST"        ; game code
    .res 6
    .byte $00           ; no expansion flash
    .byte $00           ; no expansion RAM
    .byte $00           ; not a special version
    .byte $00           ; no custom co-processor    

; Game name
    ;      123456789012345678901
    .byte "TEST ROM             "

; Cartridge header
    .byte $30           ; fast LoROM
    .byte $00           ; ROM, no RAM, no battery
    .byte $08           ; 256 KiB ROM
    .byte $00           ; no RAM
    .byte $00           ; International/Japan
    .byte $33           ; extended header
    .byte $00           ; version 1.0
    .word $ffff         ; checksum complement (placeholder)
    .word $0000         ; checksum (placeholder)

; Interrupt vectors
    .addr empty_handler
    .addr empty_handler
    .addr empty_handler ; 65816 COP
    .addr empty_handler ; 65816 BRK
    .addr empty_handler
    .addr vblank        ; 65816 NMI (vblank)
    .addr empty_handler
    .addr empty_handler ; 65816 IRQ (H/V timer)
    .addr empty_handler
    .addr empty_handler
    .addr empty_handler ; 6502 COP
    .addr empty_handler
    .addr empty_handler
    .addr empty_handler ; 6502 NMI
    .addr reset         ; 6502 RESET
    .addr empty_handler ; 6502 IRQ/BRK
