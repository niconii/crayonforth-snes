empty_handler: rti
zerobyte: .byte $00

msg: .byte "Hello, world!"
msg_end:
MSG_LEN = msg_end - msg
