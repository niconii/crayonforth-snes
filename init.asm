; SNES initialization code

; State of SNES after completion:

; 65816 registers
; ----------------------
; PB = $80, DB = $00
; P = %00000100
; A = $0000
; X = $0000
; Y = $0000
; D = $0000
; S = $01ff

; Memory
; ----------------------
; OAM   cleared with $00
; VRAM  cleared with $00
; CGRAM cleared with $00
; WRAM  cleared with $00

; PPU R/W registers
; ----------------------
; $2100 INIDISP = $8f
; $2101 OBSEL   = $00
; $2102 OAMADDL = $00
; $2103 OAMADDH = $00
; $2104 OAMDATA = $00
; $2105 BGMODE  = $00
; $2106 MOSAIC  = $00
; $2107 BG1SC   = $00
; $2108 BG2SC   = $00
; $2109 BG3SC   = $00
; $210a BG4SC   = $00
; $210b BG12NBA = $00
; $210c BG34NBA = $00
; $210d BG1HOFS = $0000
; $210e BG1VOFS = $0000
; $210f BG2HOFS = $0000
; $2110 BG2VOFS = $0000
; $2111 BG3HOFS = $0000
; $2112 BG3VOFS = $0000
; $2113 BG4HOFS = $0000
; $2114 BG4VOFS = $0000
; $2115 VMAIN   = $80
; $2116 VMADDL  = $00
; $2117 VMADDH  = $00
; $2118 VMDATAL = $00
; $2119 VMDATAH = $00
; $211a M7SEL   = $00
; $211b M7A     = $0100
; $211c M7B     = $0000
; $211d M7C     = $0000
; $211e M7D     = $0100
; $211f M7X     = $0000
; $2120 M7Y     = $0000
; $2121 CGADD   = $00
; $2122 CGDATA  = $0000
; $2123 W12SEL  = $00
; $2124 W34SEL  = $00
; $2125 WOBJSEL = $00
; $2126 WH0     = $00
; $2127 WH1     = $00
; $2128 WH2     = $00
; $2129 WH3     = $00
; $212a WBGLOG  = $00
; $212b WOBJLOG = $00
; $212c TM      = $00
; $212d TS      = $00
; $212e TMW     = $00
; $212f TSW     = $00
; $2130 CGWSEL  = $30
; $2131 CGADSUB = $00
; $2132 COLDATA = $e0
; $2133 SETINI  = $00

; WRAM registers
; ----------------------
; $2180 WMDATA  = $00
; $2181 WMADDL  = $00
; $2182 WMADDM  = $00
; $2183 WMADDH  = $00

; CPU on-chip registers
; ----------------------
; $4200 NMITIMEN= $00
; $4201 WRIO    = $ff
; $4202 WRMPYA  = $00
; $4203 WRMPYB  = $00
; $4204 WRDIVL  = $00
; $4205 WRDIVH  = $00
; $4206 WRDIVB  = $00
; $4207 HTIMEL  = $00
; $4208 HTIMEH  = $00
; $4209 VTIMEL  = $00
; $420a VTIMEH  = $00
; $420b MDMAEN  = $00
; $420c HDMAEN  = $00
; $420d MEMSEL  = $01

reset:
    ; Disable interrupts
    sei

    ; Set CPU to 65816 mode
    clc
    xce

    ; Jump to bank mirror in $80 (LoROM) or $c0 (HiROM), which
    ; will be faster after setting MEMSEL to 3.58 MHz
    jml reset_fast


reset_fast:
    ; Reset all bits except interrupt disable
    ; A/memory = 16 bits, X/Y = 16 bits
    rep #%11111011

    ; Set stack to $01ff
    lda #$01ff
    tas

    ; A/memory = 16 bits, X/Y = 8 bits
    sep #$10

    ; Set data bank to $00
    ldx #$00
    phx
    plb

    ; Set direct page to $4200
    lda #$4200
    tad

    ; A/memory = 8 bits, X/Y = 8 bits
    sep #$20

    ; MEMSEL: set banks $80-$ff to 3.58 MHz speed
    lda #$01
    sta $0d

    ; NMITIMEN: no vblank NMI, no H/V IRQ, no auto joypad read
    stz $00

    ; WRIO: set all I/O ports high-Z (input)
    lda #$ff
    sta $01

    ; WRMPYA, WRMPYB, WRDIVL, WRDIVH, WRDIVB: 0
    ; HTIMEL, HTIMEH, VTIMEL, VTIMEH: 0
    ; MDMAEN: disable all DMA channels
    ; HDMAEN: disable all HDMA channels
    ldx #$02
    :
        stz $00,x
        inx
        cpx #($0c + 1)
    bmi :-


    ; Set direct page to $2100
    lda #$21
    xba
    lda #$00
    tad

    ; INIDISP: forced blank on, brightness = 15/15 (normal)
    lda #$8f
    sta $00

    ; SETINI: no external sync, no EXTBG, no pseudo hi-res,
    ;         256x224, normal OBJ resolution, no interlace
    stz $33

    ; BGMODE: all tiles 8x8, BG3 priority normal, mode 0
    ; MOSAIC: 1x1 size, mosaic off
    ; BG1SC, BG2SC, BG3SC, BG4SC: map base VRAM address $0, 32x32
    ; BG12NBA, BG34NBA: tile base VRAM address $0
    ldx #$05
    :
        stz $00,x
        inx
        cpx #($0c + 1)
    bmi :-

    ; BG1HOFS, BG1VOFS, BG2HOFS, BG2VOFS,
    ; BG3HOFS, BG3VOFS, BG4HOFS, BG4VOFS: no scroll
    ldx #$0d
    :
        stz $00,x
        stz $00,x
        inx
        cpx #($14 + 1)
    bmi :-


    ; M7SEL: wrapping, no flip
    stz $1a

    ; M7A: 1.0
    lda #$01
    stz $1b
    sta $1b

    ; M7B: 0.0
    stz $1c
    stz $1c

    ; M7C: 0.0
    stz $1d
    stz $1d

    ; M7D: 1.0
    stz $1e
    sta $1e

    ; M7X: 0
    stz $1f
    stz $1f

    ; M7Y: 0
    stz $20
    stz $20


    ; W12SEL, W34SEL, WOBJSEL: disable windows
    ; WH0, WH1, WH2, WH3: 0
    ; WBGLOG, WOBJLOG: OR window areas together
    ; TM, TS: disable all layers
    ; TMW, TSW: don't have windows disable layers
    ldx #$23
    :
        stz $00,x
        inx
        cpx #($2f + 1)
    bmi :-


    ; CGWSEL: don't force main screen black, disable color math,
    ;         no subscreen BG/OBJ color math, no direct color
    lda #$30
    sta $30

    ; CGADSUB: add, no divide, disable color math for all layers
    stz $31

    ; COLDATA: apply b/g/r, intensity 0 (transparent subscreen backdrop)
    lda #$e0
    sta $32


clear_memory:
    ; A/memory = 16 bits, X/Y = 8 bits
    rep #$20


    ; VMAIN: increment after high, no address translation, step by 1
    ldx #$80
    stx $15

    ; Initialize VRAM
    stz $16

    lda #$8000
    :
        stz $18
        dec a
    bne :-

    stz $16


    ; A/memory = 8 bits, X/Y = 8 bits
    sep #$20


    ; Initialize CGRAM
    stz $21

    lda #$00
    :
        stz $22
        stz $22
        dec a
    bne :-


    ; A/memory = 8 bits, X/Y = 16 bits
    rep #$10


    ; OBSEL: obj size small 8x8, large 16x16,
    ;        no gap between OAM $0ff and $100, base VRAM address $0
    stz $01

    ; Initialize OAM
    stz $02
    stz $03

    ldx #$0220
    :
        stz $04
        dex
    bne :-

    stx $02


    ; Initialize WRAM
    stz $81
    stz $82
    stz $83

    ldx #$0000
    :
        stz $80
        dex
    bne :-
    :
        stz $80
        dex
    bne :-


    ; A/memory = 16 bits, X/Y = 16 bits
    rep #$20

    lda #$0000

    ; Set direct page to $0000
    tad

    ldx #$0000
    ldy #$0000

    ; Reset all bits except interrupt disable
    ; A/memory = 16 bits, X/Y = 16 bits
    rep #%11111011

    jmp start
