[bits 32]

;---------------
;   Constants
;---------------
N_ROWS equ 25
N_COLS equ 80
VIDEO_MEMORY_BEGIN equ 0xb8000
VIDEO_MEMORY_END equ VIDEO_MEMORY_BEGIN + 2 * N_ROWS * N_COLS
WHITE_ON_BLACK equ 0x0f

;--------------------
;   Prints a string in protected mode
;   Location of the string is passed by register eax.
;--------------------
print_string_pm:
    pusha

    mov ecx, eax

    mov eax, dword [CURRENT_ROW]
    mov edx, dword N_COLS
    mul edx
    shl eax, 1
    mov ebx, VIDEO_MEMORY_BEGIN
    add ebx, eax

    mov eax, ecx
    
print_string_pm_loop_begin:
    mov cl, byte [eax]
    cmp cl, byte 0
    je print_string_pm_loop_end
    mov byte [ebx], cl
    inc ebx
    mov byte [ebx], WHITE_ON_BLACK
    inc ebx
    inc eax
    jmp print_string_pm_loop_begin
print_string_pm_loop_end:

    mov ecx, dword [CURRENT_ROW]
    inc ecx
    cmp ecx, dword N_ROWS
    jl end_increment_current_row
    mov ecx, 0
end_increment_current_row:
    mov dword [CURRENT_ROW], ecx

    popa
    ret

;----------------------
;   Clears the screen
;----------------------
clear_screen_pm:
    pusha

    mov eax, VIDEO_MEMORY_BEGIN
clear_screen_loop_begin:
    mov word [eax], 0x0000
    add eax, 2
    cmp eax, VIDEO_MEMORY_END
    jge clear_screen_loop_end
    jmp clear_screen_loop_begin
clear_screen_loop_end:

    popa
    ret

;----------
;   Data   
;----------
CURRENT_ROW:
    dd 0