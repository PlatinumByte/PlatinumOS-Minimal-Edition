; PlatinumOS Minimal Edition Output API v. 1.0
    
init_output_api:
    ; --- Setting up data segments ---
    mov ax, cs
    mov ds, ax
    
    ret ; Return
print_string:
    ; --- Saving registers ---
    push ds
    push es
    push si
    push ax
    
    mov ah, 0x0E ; Function: Printing
.print_char:
    ; --- Printing string ---
    lodsb ; AL shifting
    or al, al ; Checking AL for zero
    jz .done ; If AL is zero, go to .done
    int 0x10 ; Interrupting
    jmp .print_char ; If AL is not zero, go to .print_char
.done:
    ; --- Restoring registers ---
    pop ds
    pop es
    pop si
    pop ax
    
    ret ; Return
print_char:
    ; --- Saving registers ---
    push ds
    push es
    push si
    push ax
    
    mov ah, 0x0E ; Function: Printing
    int 0x10
.done:
    ; --- Restoring registers ---
    pop ds
    pop es
    pop si
    pop ax
    
    ret ; Return
print_newline:
    ; --- Saving registers ---
    push ds
    push es
    push si
    push ax
    
    ; --- Printing newline ---
    mov ah, 0x0E ; Function: Printing
    mov al, 0x0D ; Carriage return
    int 0x10 ; Interrupting
    mov al, 0x0A ; Line Feed
    int 0x10 ; Interrupting
    jmp .done ; Going to .done
.done:
    ; --- Restoring registers ---
    pop ds
    pop es
    pop si
    pop ax
    
    ret ; Return