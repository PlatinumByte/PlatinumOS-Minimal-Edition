; PlatinumOS Minimal Edition Kernel v. 1.0

[BITS 16] ; 16 bits
[ORG 0x0000] ; Program address

start:
    ; --- Setting up data segments ---
    mov ax, cs
    mov ds, ax ;
    mov es, ax ;
    
    ; --- Minimal stack initialization ---
    cli ; Disabling interrupts
    mov ax, 0x2000
    mov ss, ax
    mov sp, 0x8000
    sti ; Enabling interrupts
    
    call init_output_api ; Output API initialization
    
    call print_newline ; Printing newline
    
    mov si, msg
    call print_string ; Printing message
    
    jmp $
    
%INCLUDE "output_api.asm"
msg db 'Platinum OS Minimal Edition Kernel is running!', 13, 10, 0