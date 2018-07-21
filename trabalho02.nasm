%macro scan 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

section .data
    x db '5'
    y db '3'
    msg db  "sum of x and y is "
    len equ $ - msg

segment .bss
    vetor resb 200

global _start

_start:
    scan vetor, 200
    

    int     0x80
quick_srot:
    enter
    
leave
ret

partition:
    enter
    
leave
ret
