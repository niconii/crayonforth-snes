macro init_snes() {
                // disable interrupts
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
}
