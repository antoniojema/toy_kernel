;------------
;   Loads `dh` sectors from drive `dl` into es:bx
;------------
disk_load:
    pusha

    push dx

    mov ah, 0x02  ; ah <- function 0x02 (int 0x13) = 'read'
    mov al, dh    ; al <-number of sectors to read
    mov cl, 0x02  ; cl <- sector number
    mov ch, 0x00  ; ch <- cylinder number
                  ; dl <- drive number set from the caller
    mov dh, 0x00  ; dh <- head number
                  ; [es:bx] <- buffer address set from the caller
    int 0x13
    jc disk_load_error

    pop dx
    cmp al, dh    ; al = number of sectors read (returned by BIOS)
    jne sectors_error

    popa
    ret

disk_load_error:
    mov ax, disk_error_msg
    call print_string
    mov al, ah          ; ah = error code
    call print_byte_hex
    call print_endl
    jmp disk_loop

sectors_error:
    mov ax, sectors_error_msg
    call print_string
    call print_endl

disk_loop:
    jmp $

disk_error_msg:
    db "Disk read error. Error code: ", 0

sectors_error_msg:
    db "Sectors read not equal to sectors asked", 0