;https://www.jdoodle.com/compile-assembler-nasm-online
%macro imprima 2
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

%macro leia 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    topo_pilha resd 1
    expressao_pos resb 200
    contador resd 1
    expressao resb 200
    i resw 1
    char_atual resb 1
    auxiliar resb 1
    abre_p resw 1
    fecha_p resw 1
    
section .text
    global _start
    
_start:
    mov dword [topo_pilha],esp
    leia expressao, 200
    mov dword [contador], 0x0
    mov ebx, 0x0
    mov [i],ebx
    mov eax, '('
    push eax
volta_inicio:
    ;mov byte [contador], 0x0
    
    mov eax, 0x0
    mov al, [expressao + ebx]
    add ebx,1
    mov byte [char_atual], al
    cmp al, '='
    je o_fim
    cmp al, '('
    je par_abr
    cmp al,')'
    je par_fec
    cmp al, '+'
    je mais_ou_menos
    cmp al, '-'
    je mais_ou_menos
    cmp al, '*'
    je mult_ou_div
    cmp al, '/'
    je mult_ou_div
    ;------------------------
    mov dword edx, [contador]
    mov al, [char_atual]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    imprima char_atual, 1
    jmp volta_inicio

;------------------
par_abr:
    mov eax, [char_atual]
    push eax
    jmp volta_inicio
;------------------
par_fec:
    ;Implementar parte que verifica estouro de pilha
    pop ecx
    cmp cl,'('
    je volta_inicio
    mov byte [auxiliar], cl
    ;------------------------
    mov dword edx, [contador]
    mov al, [char_atual]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    imprima auxiliar, 1 
    jmp par_fec
;------------------
mais_ou_menos:
    pop ecx
    cmp cl, '('
    je fim_mais_ou_menos
    mov [auxiliar],cl
    ;------------------------
    mov dword edx, [contador]
    mov al, [char_atual]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    imprima auxiliar, 1
    jmp mais_ou_menos
fim_mais_ou_menos:
    mov ecx, '('
    push ecx
    mov ecx, [char_atual]
    push ecx
    jmp volta_inicio
;------------------
mult_ou_div:
    pop ecx
    cmp cl, '('
    je fim_mult_ou_div
    cmp cl, '+'
    je fim_mult_ou_div
    cmp cl, '-'
    je fim_mult_ou_div
    mov [auxiliar], cl
    ;------------------------
    mov dword edx, [contador]
    mov al, [char_atual]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    imprima auxiliar, 1
    jmp mult_ou_div
fim_mult_ou_div:
    push ecx
    mov ecx, [char_atual]
    push ecx
    jmp volta_inicio
;------------------

o_fim:
    mov byte [char_atual],0xa
    imprima char_atual,1
    mov edx, 0x0
    mov al, [expressao_pos +edx]
    mov [char_atual],al
    imprima char_atual,1
    mov eax, [topo_pilha]
    cmp eax, esp
    je o_fim2                   ;encaminhar para erro
    
    
    
o_fim2:
    ; Chamar a função de verificação da pilha
    ; Verificar reg esp
    fim
