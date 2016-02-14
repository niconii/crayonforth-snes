arch snes.cpu

macro seek(variable offset) {
    origin ((offset & $7f0000) >> 1) | (offset & $007fff)
    base offset
}

// ROM HEADER
seek(0x00ffc0)
  //123456789012345678901
db "TEST ROM             " // cartridge title
seek(0x00ffd5)
db %00110000 // fast LoROM
db $00 // ROM, no RAM, no battery
db $08 // 256 KB rom
db $00 // no ram
db $00 // international/japan
db $33 // extended header
db $00 // version 1.0
dw $ffff // checksum complement (placeholder)
dw $0000 // checksum (placeholder)

// EXTENDED HEADER
seek(0x00ffb0)
db "N&" // maker code
db "TEST" // game code
db 0,0,0,0,0,0 // reserved
db $00 // no expansion flash
db $00 // no expansion ram
db $00 // not a special version
db $00 // no custom co-processor

seek(0x00ffe0)
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

seek(0x008000)

empty_handler:
                rti


reset:          // disable interrupts
                sei

                // switch to 65816 mode
                clc
                xce

                // reset flags, set mem/A = 16 bit, X/Y = 16 bit
                // but keep interrupts off
                rep #%11111011

                // set data bank = program bank
                phk
                plb

                // set direct page = $0000
                lda #$0000
                tcd

                // set up stack
                ldx #$1fff
                txs

                sep #$20        // mem/A = 8 bit

                // turn off screen, normal brightness
                lda #%10001111
                sta $2100

                stz $2101
                stz $2102
                stz $2103

                // reset $2105-$210c
                // (set sprite/character/tile sizes to lowest, set addresses to 0)
                ldx #$2105
            -
                stz $00,x
                inx
                cpx #($210c + 1)
                bne -

                // reset $210d-$2114
                // (set all BG scroll values to $0000)
            -
                stz $00,x
                stz $00,x
                inx
                cpx #($2114 + 1)
                bne -

                lda #$80
                sta $2115       // set VRAM transfer mode to word-access, increment by 1

                stz $2116       // vram address = $0000
                stz $2117

                // $2118-$2119 writes to vram, don't need to initialize

                stz $211a       // clear mode7 setting

                lda #$01

                stz $211b
                sta $211b

                stz $211c
                stz $211c

                stz $211d
                stz $211d

                stz $211e
                sta $211e

                stz $211f
                stz $211f

                stz $2120
                stz $2120

                stz $2121

                ldx #$2123
            -
                stz $00,x
                inx
                cpx #($212e + 1)
                bne -

                lda #$30
                sta $2130

                stz $2131

                lda #$e0
                sta $2132

                stz $2133

                stz $4200

                lda #$ff
                sta $4201

                ldx #$4202
            -
                stz $00,x
                inx
                cpx #($420d + 1)
                bne -

                // clear VRAM
                rep #$20        // set mem/a=16-bit

                ldx #$8000
            -
                stz $2118
                dex
                bne -

                stz $2116

                sep #$20        // set mem/a=8-bit

                // clear CGRAM
                ldx #$0100
            -
                stz $2122
                stz $2122
                dex
                bne -

                // clear WRAM
                ldx #$0000
            -
                stz $2180
                dex
                bne -
            -
                stz $2180
                dex
                bne -

                cli

turn_on_screen:
                lda #$0f
                sta $2100

blue_screen:
                lda #%01111100

                stz $2122
                sta $2122

set_up_hdma:
                lda #%00000011
                sta $4300

                lda #$21
                sta $4301

                lda.b #(hdma_table & $0000ff)
                sta $4302

                lda.b #((hdma_table & $00ff00) >> 8)
                sta $4303

                lda.b #((hdma_table & $ff0000) >> 16)
                sta $4304

                lda #%00000001
                sta $420c

forever:
                jmp forever

hdma_table:
db $07
dw $0000,%00000000'00000001
db $07
dw $0000,%00000000'00000011
db $07
dw $0000,%00000000'00000111
db $07
dw $0000,%00000000'00001110
db $07
dw $0000,%00000000'00011100
db $07
dw $0000,%00000000'00111000
db $07
dw $0000,%00000000'01110000
db $07
dw $0000,%00000000'11100000
db $07
dw $0000,%00000001'11000000
db $07
dw $0000,%00000011'10000000
db $07
dw $0000,%00000111'00000000
db $07
dw $0000,%00001110'00000000
db $07
dw $0000,%00011100'00000000
db $07
dw $0000,%00111000'00000000
db $07
dw $0000,%01110000'00000000
db $07
dw $0000,%00000000'00000001
db $07
dw $0000,%00000000'00000011
db $07
dw $0000,%00000000'00000111
db $07
dw $0000,%00000000'00001110
db $07
dw $0000,%00000000'00011100
db $07
dw $0000,%00000000'00111000
db $07
dw $0000,%00000000'01110000
db $07
dw $0000,%00000000'11100000
db $07
dw $0000,%00000001'11000000
db $07
dw $0000,%00000011'10000000
db $07
dw $0000,%00000111'00000000
db $07
dw $0000,%00001110'00000000
db $07
dw $0000,%00011100'00000000
db $07
dw $0000,%00111000'00000000
db $07
dw $0000,%01110000'00000000
db $01
dw $0000,%01111111'11111111
db $00
