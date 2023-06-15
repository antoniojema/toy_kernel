;---------------
;  Prints a null-terminated string
;  Takes the address of the beginning of the
;  string in al
;--------------- 
print_char:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret

;---------------
;  Prints a null-terminated string
;  Takes the address of the beginning of the
;  string in ax
;--------------- 
print_string:
    pusha
    mov bx, ax
    mov ah, 0x0e
print_string_loop_begin:
    mov al, [bx]
    cmp al, 0
    je print_string_loop_end
    int 0x10
    add bx, 1
    jmp print_string_loop_begin
print_string_loop_end:
    popa
    ret

;---------------
;  Prints new line (0xa 0xd)
;--------------- 
print_endl:
    pusha
    mov ax, endl_string
    call print_string
    popa
    ret
endl_string:
    db 0xa, 0xd, 0

;---------------
;  Prints a string representing a byte in hex
;  Takes the number in al
;--------------- 
print_byte_hex:
    pusha

    mov cl, 0
    mov ch, 0

byte_hex_loop_begin:
    mov ah, al
    shr ah, cl
    and ah, 0x0f
    cmp ah, 0x0a
    jge byte_read_letter
byte_read_number:
    add ah, '0'
    jmp byte_end_read

byte_read_letter:
    add ah, 'A' - 0x0a
    jmp byte_end_read

byte_end_read:
    mov bx, byte_string + 3
    mov dl, ch
    sub bx, dx
    mov [bx], ah

    inc ch
    cmp ch, 2
    jge byte_hex_loop_end
    add cl, 4
    jmp byte_hex_loop_begin

byte_hex_loop_end:

    mov ax, byte_string
    call print_string

    popa
    ret

byte_string:
    db "0x00", 0

;---------------
;  Prints a string representing a word in hex
;  Takes the number in ax
;--------------- 
print_word_hex:
    pusha
    sub sp, 4

    mov bx, sp
    add bx, 4
    mov [bx], ax
    sub bx, 2
    mov word [bx], 0
    sub bx, 1
    mov word [bx], 0

word_hex_loop_begin:
    mov bx, sp
    add bx, 4
    mov ax, [bx]    ; ax = number
    sub bx, 3
    mov cl, [bx]    ; cl = shr_amount
    shr ax, cl      ; ax = number >> shr_amount
    and ax, 0x000f
    cmp ax, 0x000a
    jge word_read_letter
word_read_number:
    add ax, '0'
    jmp word_end_read

word_read_letter:
    add ax, 'A' - 0x0a
    jmp word_end_read

word_end_read:
    mov bx, sp
    add bx, 2
    mov cl, [bx]            ; cx = cnt
    movzx cx, cl            ;
    mov bx, word_string + 5
    sub bx, cx              ; bx = word_string + 5 - cnt

    mov [bx], al

    mov bx, sp
    add bx, 2
    mov al, [bx]
    inc al
    cmp al, 4
    jge word_hex_loop_end
    mov [bx], al
    sub bx, 1
    mov al, [bx]
    add al, 4
    mov [bx], al
    jmp word_hex_loop_begin

word_hex_loop_end:

    mov ax, word_string
    call print_string

    add sp, 4
    popa
    ret

word_string:
    db "0x0000", 0