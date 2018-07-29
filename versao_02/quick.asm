
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
    mov ecx, [esp + 4]  ;ebx = superior_p
    mov dword [superior_p], ecx
    mov ebx, [esp + 8]  ;ecx = inferior_p
    mov dword [inferior_p], ebx
    
;---------------------------------------------------
    ;mov dword [teste], '*'
    ;print teste, 1
    shl ecx, 2
    mov eax, [vetor_numerico+ecx]           ;eax vai ter v[superior]
    mov dword [pivo], eax
    sub ebx, 1                              ;ebx vai ficar com valor de i
    mov dword [i], ebx
    mov eax, [esp+8]
    mov dword [j], eax
    loop1:
    
    mov eax, [j]
    mov ebx, [superior_p]
    sub ebx, 1
    cmp eax, ebx
    jg fim_partition
    
    ;-------------------------
    ;mov eax, [j]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste, 1
    ;mov eax, [superior_p]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste, 1
    ;mov dword [teste], 0xa
    ;print teste, 1
    ;-------------------------
    
    mov eax, [j]
    shl eax, 2
    mov ebx, [vetor_numerico+eax]
    mov eax, [pivo]
    cmp ebx, eax
    jg comp_partition
    mov eax, [i]
    add eax,1
    mov dword [i], eax
    mov ebx, [j]
    swap [vetor_numerico+eax], [vetor_numerico+ebx]
    comp_partition:
    mov eax, [j]
    add eax, 1
    mov dword [j], eax
    jmp loop1
    
    fim_partition:
    mov eax, [i]
    add eax,1
    mov ebx, [superior_p]
    shl eax, 2
    shl ebx,2
    swap [vetor_numerico+eax], [vetor_numerico+ebx]
    mov eax, [i]
    add eax, 1
;---------------------------------------------------
    
    ;pop ebp
    ret
    
    
quicksort:              ;esp armazena q em endereço -4
    ;----------------------------
    mov dword [teste], '*'
    print teste, 1
    ;----------------------------
    ; -------------------------------- pega parâmetros
    mov ecx, [esp + 4]  ;ebx = superior_q
    mov ebx, [esp + 8]  ;ecx = inferior_q
    mov dword [inferior_q], ebx
    mov dword [superior_q], ecx
    ; -------------------------------- armazenar variaveis locais
    ;-------------------------
    ;mov eax, [inferior_q]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste, 1
    ;mov eax, [superior_q]
    ;add eax, '0'
    ;mov dword [teste], eax
    ;print teste, 1
    ;mov dword [teste], 0xa
    ;print teste, 1
    ;-------------------------
    push ebp
    mov ebp, esp
    ;sub esp, 12
    ; -------------------------------- começo da função
    ;mov dword [ebp-4], ecx              ;superior_q
    ;mov dword [ebp-8], ebx               ;inferior_q
    cmp ebx, ecx
    jge eh_maior_ou_igual
    
    push ebx                            ;empilhei primeiro o inferior                            
    push ecx                            ;depois superior
    
    call partition
    
    
    pop ebx
    pop ebx
    
   
    mov dword [ebp-12], eax
    
    mov ebx, [inferior_q]               ;passa como parâmetro inferior_q, divisor-1
    mov eax, [ebp-12]
    sub eax, 1
    push ebx
    push eax
    
    call quicksort
    pop ebx
    pop ebx
    
    mov eax, [ebp-12]                    ;passa como parâmetro divisor+1, superior_q
    add eax, 1
    push eax
    mov ebx, [superior_q]
    push ebx
    
    call quicksort
    pop ebx
    pop ebx
    
    eh_maior_ou_igual:
    ; -------------------------------- fim da fç
    ;mov esp, ebp
    pop ebp
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
    ;mov eax, [vetor_numerico]
    ;mov ebx, [vetor_numerico+8]
    ;mov dword [vetor_numerico+8], eax
    ;mov dword [vetor_numerico],ebx
    ;swap [vetor_numerico], [vetor_numerico+4]
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
    