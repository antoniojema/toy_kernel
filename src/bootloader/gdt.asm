;-----------
;   GDT
;-----------
gdt_start:

gdt_null:
    dq 0

gdt_code:
    ; base = 0x0
    ; limit = 0xffffff
    ; Flags 1: Present=1, Privilege=00, Descriptor type= 1 -> 0b1001
    ; Type flags: Code=1, Conforming=0, Readable=1, Accessed=0 -> 0b1010 
    ; Flags 2: Granularity=1, 32-bit=1, 64-bit=0, Available=0 -> 0b1100
    dw 0xffff      ; Segment Limit (0-15)
    dw 0x0         ; Base address (0-15)
    db 0x0         ; Base address (16-23)
    db 0b10011010  ; Flags 1 + Type
    db 0b11001111  ; Flags 2 + Segment limit (16-19)
    db 0x0         ; Base address (24-31)

gdt_data:
    ; base = 0x0
    ; limit = 0xffffff
    ; Flags 1: Present=1, Privilege=00, Descriptor type= 1 -> 0b1001
    ; Type flags: Data=0, Expand-down=0, Writable=1, Accessed=0 -> 0b1010 
    ; Flags 2: Granularity=1, 32-bit=1, 64-bit=0, Available=0 -> 0b1100
    dw 0xFFFF      ; Segment Limit (0-15)
    dw 0x0         ; Base address (0-15)
    db 0x0         ; Base address (16-23)
    db 0b10010010  ; Flags 1 + Type
    db 0b11001111  ; Flags 2 + Segment limit (16-19)
    db 0x0         ; Base address (24-31)

gdt_end:

;-------------------
;   GDT descriptor
;-------------------
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

;---------------
;   Constants
;---------------
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start