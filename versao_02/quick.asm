
; Macro criada para imprimir dados na tela
%macro print 2
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro criada para ler os dados de entrada
%macro scan 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

%macro swap 2
    pushad
    mov eax, %1
    mov ebx, %2
    mov %1, ebx
    mov %2, eax
    popad
%endmacro

%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    vetor_entrada resb 200
    vetor_numerico resd 200
    char_atual resb 1
    n resd 1
    inferior_q resd 1
    inferior_p resd 1
    superior_q resd 1
    superior_p resd 1
    divisor resd 1
    pivo resd 1
    i resd 1
    j resd 1
    teste resd 1
    
    
section .text
global _start

partition:
    enter 20,0
    mov eax, [ebp+8]
    mov ebx, [ebp+12]
    mov dword [ebp-4], ebx                      ;ebp-4 tem o primeiro parâmetro (inferior)
    mov dword [ebp-8], eax                      ;ebp-8 tem o segundo parâmetro  (superior)
    
    shl eax, 2
    mov ebx, [vetor_numerico+eax]
    mov dword [ebp-12], ebx                     ;ebp-12 tem o valor do pivô
    mov eax, [ebp-4]
    sub eax, 1
    mov dword [ebp-16], eax                     ;ebp-16 tem i
    mov eax, [ebp-4]
    mov dword [ebp-20], eax                     ;ebp-20 tem j
    
    
    loop1:
    mov eax, [ebp-20]
    mov ebx, [ebp-8]
    sub ebx, 1
    cmp eax,ebx
    jg fim_laco2
    
    mov eax, [ebp-20]
    shl eax, 2
    mov ebx, [vetor_numerico+eax]
    mov ecx, [ebp-12]
    cmp ebx, ecx
    jg inc_loop
    
    mov eax, [ebp-16]
    add eax, 1
    mov dword [ebp-16], eax
    
    mov eax, [ebp-16]
    mov ebx, [ebp-20]
    shl eax, 2
    shl ebx, 2
    

    mov ecx, [vetor_numerico+eax]
    mov edx, [vetor_numerico+ebx]
    mov dword [vetor_numerico+ebx], ecx
    mov dword [vetor_numerico+eax], edx
    
    inc_loop:
    mov eax, [ebp-20]
    add eax, 1
    mov dword [ebp-20], eax
    jmp loop1
    
    fim_laco2:
    
    mov eax, [ebp-16]
    add eax, 1
    shl eax, 2
    mov ebx, [ebp-8]
    shl ebx, 2
    
    mov ecx, [vetor_numerico+eax]
    mov edx, [vetor_numerico+ebx]
    mov dword [vetor_numerico+ebx], ecx
    mov dword [vetor_numerico+eax], edx
    
    mov eax, [ebp-16]
    add eax, 1
    leave
    ret
    
quicksort:

    ;mov dword [teste], '*'
    ;print teste, 1
    enter 12,0
    ;push eax
    
    mov ecx, [ebp + 8]
    mov ebx, [ebp + 12]
    mov dword [ebp-4], ebx                      ;ebp-4 tem o inferior
    mov dword [ebp-8], ecx                      ;ebp-8 tem o superior
    cmp ebx, ecx
    jge fim_quicksort
    ;------------------------------
    ;mov eax, [ebp-4]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste,1
    ;mov eax, [ebp-8]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste,1
    ;------------------------------
    ;pop eax
    
    mov eax, [ebp-4]
    push eax
    mov eax, [ebp-8]
    push eax
    call partition
    pop ebx
    pop ebx
    ;add eax, '0'
    ;mov dword [teste],eax
    ;print teste, 1
    mov dword [ebp-12], eax                     ;divisor ta em [ebp-12]
    mov eax, [ebp-4]
    push eax
    mov eax, [ebp-12]
    sub eax, 1
    push eax
    call quicksort
    pop eax
    pop eax
    
    mov eax, [ebp-12]
    add eax, 1
    push eax
    mov eax, [ebp-8]
    push eax
    call quicksort
    pop eax
    pop eax
    
    fim_quicksort:
    leave
    ret

_start:
    scan vetor_entrada, 200
    ; aqui deve entrar o techo do código que converte a string para inteiro.
    mov eax, 0x0
    mov ebx, 0x0
    mov ecx, 0x0
    mov dword [n], eax
    
volta_inicio:
    mov al, [vetor_entrada + ebx]
    cmp al, 0xa
    je fim_laco
    cmp al, 0x20
    je fim_espaco
    ;----- se for negativo, implementar
    sub al,'0'
    movsx eax, al
    mov dword [vetor_numerico + ecx], eax
    add ecx, 4
    
    mov edx, [n]
    add edx, 1
    mov dword [n], edx
    
    fim_espaco:
    add ebx, 1
    jmp volta_inicio
    ; em vetor_numerico vou admitir que existe um vetor com valores para serem ordenados
    ;n indica tamanho do vetor
    
fim_laco:
    ;mov dword [n], ecx
    mov eax, 0x0
    push eax
    mov eax, [n]                        ;Falta definir o valor de n
    sub eax, 1
    push eax
    
    mov eax, [n]
    add eax, '0'
    mov [teste], eax
    ;print teste, 1
    
    call quicksort
    pop eax                             
    pop eax
    
    mov ebx, 0x0
print_array:
    mov ecx, [vetor_numerico + ebx]
    add ecx, '0'
    mov byte [char_atual], cl
    
    print char_atual, 1
    add ebx, 4
    
    mov ecx, [n]
    shl ecx, 2
    cmp ebx, ecx ; Compara se o contador é igual ao tamanho do vetor
    jl print_array
    fim
    
