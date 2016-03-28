reset:
    // Disable interrupts
    sei

    // Set CPU to 65816 mode
    clc
    xce

    // Jump to bank mirror in $80-$ff, which will be
    // faster after setting MEMSEL
    jml reset_fast


reset_fast:
    // Reset all bits except interrupt disable
    // A/memory = 16 bits, X/Y = 16 bits
    rep #%11111011

    // Set stack to $01ff
    lda #$01ff
    tas

    // A/memory = 16 bits, X/Y = 8 bits
    sep #$10

    // Set data bank to $00
    ldx #$00
    phx
    plb

    // Set direct page to $4200
    lda #$4200
    tad

    // A/memory = 8 bits, X/Y = 8 bits
    sep #$20

    // MEMSEL: set banks $80-$ff to 3.58 MHz speed
    lda #$01
    sta $0d

    // NMITIMEN: no vblank NMI, no H/V IRQ, no auto joypad read
    stz $00

    // WRIO: set all I/O ports high-Z (input)
    lda #$ff
    sta $01

    // WRMPYA, WRMPYB, WRDIVL, WRDIVH, WRDIVB: 0
    // HTIMEL, HTIMEH, VTIMEL, VTIMEH: 0
    // MDMAEN: disable all DMA channels
    // HDMAEN: disable all HDMA channels
    ldx #$02
-
    stz $00,x
    inx
    cpx.b #($0c + 1)
    bmi -


    // Set direct page to $2100
    lda #$21
    xba
    lda #$00
    tad

    // INIDISP: forced blanking, normal brightness
    lda #$8f
    sta $00

    // SETINI: no external sync, no EXTBG, no pseudo hi-res,
    //         256x224, normal OBJ resolution, no interlace
    stz $33

    // BGMODE: all tiles 8x8, BG3 priority normal, mode 0
    // MOSAIC: 1x1 size, mosaic off
    // BG1SC, BG2SC, BG3SC, BG4SC: base address $0, 32x32
    // BG12NBA, BG34NBA: tile base address $0
    ldx #$05
-
    stz $00,x
    inx
    cpx.b #($0c + 1)
    bmi -

    // BG1HOFS, BG1VOFS, BG2HOFS, BG2VOFS,
    // BG3HOFS, BG3VOFS, BG4HOFS, BG4VOFS: no scroll
    ldx #$0d
-
    stz $00,x
    stz $00,x
    inx
    cpx.b #($14 + 1)
    bmi -


    // M7SEL: wrapping, no flip
    stz $1a

    // M7A: 1.0
    lda #$01
    stz $1b
    sta $1b

    // M7B: 0.0
    stz $1c
    stz $1c

    // M7C: 0.0
    stz $1d
    stz $1d

    // M7D: 1.0
    stz $1e
    sta $1e

    // M7X: 0
    stz $1f
    stz $1f

    // M7Y: 0
    stz $20
    stz $20


    // W12SEL, W34SEL, WOBJSEL: disable windows
    // WBGLOG, WOBJLOG: OR windows
    // TMW, TSW: don't disable layers
    ldx #$23
-
    stz $00,x
    inx
    cpx.b #($2f + 1)
    bmi -


    // CGWSEL: don't force main screen black, disable color math,
    //         no subscreen BG/OBJ color math, use palettes
    lda #$30
    sta $30

    // CGADSUB: add, no divide, disable color math for all layers
    stz $31

    // COLDATA: apply b/g/r, intensity 0 (transparent subscreen backdrop)
    lda #$e0
    sta $32


clear_memory:
    // A/memory = 16 bits, X/Y = 8 bits
    rep #$20


    // VMAIN: increment after high, no address translation, step by 1
    ldx #$80
    stx $15

    // Initialize VRAM
    stz $16

    lda #$8000
-
    stz $18
    dec
    bne -

    stz $16


    // A/memory = 8 bits, X/Y = 8 bits
    sep #$20


    // Initialize CGRAM
    stz $21

    lda #$00
-
    stz $22
    stz $22
    dec
    bne -


    // A/memory = 8 bits, X/Y = 16 bits
    rep #$10


    // OBSEL: obj size small 8x8, large 16x16,
    //        no gap between $0ff and $100, base address $0
    stz $01

    // Initialize OAM
    stz $02
    stz $03

    ldx #$0220
-
    stz $04
    dex
    bne -

    stx $02


    // Initialize WRAM
    stz $81
    stz $82
    stz $83

    ldx #$0000
-
    stz $80
    dex
    bne -
-
    stz $80
    dex
    bne -


    // A/memory = 16 bits, X/Y = 16 bits
    rep #$20

    lda #$0000

    // Set direct page to $0000
    tad

    ldx #$0000
    ldy #$0000

    // Reset all bits except interrupt disable
    // A/memory = 16 bits, X/Y = 16 bits
    rep #%11111011
