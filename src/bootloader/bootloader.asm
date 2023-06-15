[org 0x7c00]

KERNEL_OFFSET equ 0x1000

[bits 16]
    ; Set stack pointer
    mov bp, 0x9000
    mov sp, bp

    ; Save boot drive
    mov [BOOT_DRIVE], dl

    ; Print message
    mov ax, MSG_BEGIN
    call print_string
    call print_endl

    ; Load kernel and switch to 32-bit
    call load_kernel
    call switch_to_pm

load_kernel:
    ; Load 15 sectors from drive BOOT_DRIVE to 0x0:KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    mov ax, 0x0
    mov es, ax
    mov bx, KERNEL_OFFSET

    call disk_load
    ret

switch_to_pm:
    ; Clear interrupts
    cli

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Switch to 32-bit
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Begin protected mode execution
    jmp CODE_SEG:start_protected_mode


;-------------
;   Include
;-------------
%include "src/bootloader/gdt.asm"
%include "src/bootloader/print.asm"
%include "src/bootloader/disk_load.asm"


;--------------
;   Real mode
;--------------
[bits 32]
start_protected_mode:
    ; Set segment pointers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set stack pointers
    mov ebp, 0x90000
    mov esp, ebp

    ; Jump to kernel start
    call KERNEL_OFFSET
    
    jmp $

;----------
;   Data
;----------
BOOT_DRIVE:
    db 0

MSG_BEGIN:
    db "Loading kernel and switching to 32-bit...", 0

;---------
;   End
;---------
times 510-($-$$) db 0
db 0x55, 0xAA
