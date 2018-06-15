;https://www.ime.usp.br/~pf/algoritmos/aulas/footnotes/polonesa-pseudocode.html

%macro imprima 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    
%endmacro

%macro leia 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    dadolido resb 1
    
section .text
    global _start
    
_start:
inicio:
    leia dadolido, 1
    mov eax, [dadolido]
    cmp eax, 0xa            ;cmp com quebra de linha
    jz ofim                  ;se for quebra de linha, fim
    cmp eax, '('            ;verifica se é chave abrindo
    jz ehparentesesabrindo
    jmp nehparentesesabrindo

ehparentesesabrindo:
    push eax
    jmp inicio         ;salta todos os outros ifs
nehparentesesabrindo:
    cmp eax, ')'
    jz ehparentesesfechando
    jmp nehparentesesfechando
ehparentesesfechando:
    jmp inicio         ;salta todos os outros ifs
nehparentesesfechando:
    cmp eax,'+'
    jz ehsomaousub
    cmp eax, '-'
    jz ehsomaousub
    jmp nehsomaousub
ehsomaousub:
    -----
    
    jmp inicio         ;salta todos os outros ifs
nehsomaousub:
    cmp eax, '*'
    jz ehmuloudiv
    cmp eax, '/'
    jz ehmuloudiv
    jmp nehmuloudiv
    
ehmuloudiv:
    ------
    jmp inicio         ;salta todos os outros ifs
nehmuloudiv:
    imprima eax,1       ;se chegar aqui é numero, e numero imprime
    
    
ofim:
    fim
    
