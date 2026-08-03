; PlatinumOS Minimal Edition Bootloader v. 1.0

[BITS 16] ; 16 bits
[ORG 0x7C00] ; Program address

start:
    ; --- Minimal stack initialization ---
    cli ; Disabling interrupts
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00
    sti ; Enabling interrupts
    
    mov [boot_drive], dl ; Saving a disk
    
    ; --- Configuring a kernel address (0x1000:0000) ---
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    
    ; --- Setting sector for read ---
    mov ah, 0x02 ; Function: Reading
    mov al, 1 ; Read 1 sector
    mov ch, 0 ; Cylinder 0
    mov cl, 16 ; Sector 16
    mov dh, 1 ; Head 1
    mov dl, [boot_drive] ; Loading the disk from variable
    
    ; --- READING! ---
    int 0x13 ; Interrupting
    jc read_error ; If there is an error, go to read_error.
    mov ah, 0x0E ; Function: Printing
    mov al, 'Y' ; 'Y' symbol. If you see this symbol, the bootloader successfully read the disk.
    int 0x10 ; Printing on screen
    
    ; --- Transition to the kernel ---
    jmp 0x1000:0000 ; Transitioning to the kernel;
    
read_error:
    mov ah, 0x0E ; Function: Printing
    mov al, 'E' ; 'E' symbol. If you see this, it means the bootloader was unable to read the disk.
    int 0x10 ; Printing on screen
    jmp $ ; Your computer freezes

; --- End of bootloader ---
boot_drive db 0
times 510-($-$$) db 0
dw 0xAA55