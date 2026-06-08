[BITS 16]
org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov ah, 0x02                
    mov al, 1                   ;à ajuster
    mov ch, 0                   
    mov cl, 2                   
    mov dh, 0                   
    

    mov bx, 0x0000
    mov es, bx
    mov bx, 0x1000              
    int 0x13                    
    jc disk_error               

    
    jmp switch_to_32bit

disk_error:
    
    hlt
    jmp disk_error

switch_to_32bit:
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[BITS 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    
    
    jmp CODE_SEG:0x1000

align 4
gdt_start:
gdt_null:
    dd 0x00000000
    dd 0x00000000
gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510 - ($ - $$) db 0
dw 0xAA55
