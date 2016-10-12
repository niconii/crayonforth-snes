empty_handler: rti
zerobyte: .byte $00

banner1: .byte "CrayonForth for SNES v0.0.1"
banner1_end:
BANNER1_LEN = banner1_end - banner1

banner2: .byte "(c) 2016 Nicolette Verlinden"
banner2_end:
BANNER2_LEN = banner2_end - banner2