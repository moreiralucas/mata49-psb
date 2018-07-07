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

section .data
    msg_com_erro db "Erro de formatação"
    len1 equ $ - msg_com_erro
    msg_sem_erro db "Bem formatada"
    len2 equ $ - msg_sem_erro

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
    mov dword [topo_pilha], esp
    leia expressao, 200
    mov dword [contador], 0x0
    mov ebx, 0x0
    mov [i], ebx
    mov eax, '('
    push eax
volta_inicio:
    ;mov byte [contador], 0x0
    mov eax, 0x0
    mov al, [expressao + ebx]
    add ebx,1
    mov byte [char_atual], al
    cmp al, 0xa ; Compara se é fim de linha
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
    mov ecx, [topo_pilha]
    cmp ecx, esp
    je msg_error
    pop ecx
    cmp cl,'('
    je volta_inicio
    mov byte [auxiliar], cl
    ;------------------------
    mov dword edx, [contador]
    mov al, [auxiliar]
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
    mov al, [auxiliar]
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
    mov al, [auxiliar]
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
    ;Inicia trecho para tratar o '(' que é inserido no início do algoritmo
;par_fec_fim: 
    ;mov ecx, [topo_pilha]
    ;cmp ecx, esp
    ;je msg_error
    
    ;pop ecx
    ;cmp cl,'('
    ;je continua_o_fim
    ;mov byte [auxiliar], cl
    ;------------------------
    ;mov dword edx, [contador]
    ;mov al, [auxiliar]
    ;mov byte [expressao_pos + edx], al
    ;inc edx
    ;mov dword [contador],edx
    ;------------------------
    ;imprima auxiliar, 1 
    ;jmp par_fec_fim
    ;------------------
;continua_o_fim:
    mov eax, [topo_pilha]
    cmp eax, esp
    jne msg_error                  ;encaminhar para erro
    ;---------------------------- parte da pilha de calculo de operações do sr lucas
    
    ;----------------------------
    mov eax, [contador]         ;eax eu uso pro contador (sei o total de espaços utilizaods na pilha)
    ;sub eax, 1                  ;ebx eu uso na leitura de variáveis
    mov ecx, 0x0                ;ecx eu uso como 'i' e como pilha
    mov [i], ecx
check_operator:                 ;edx eu uso how
    mov eax, [contador]
    mov ecx, [i]
    ;add ecx, '0'
    cmp ecx, eax
    je o_fim2
    ;---------------------------
    mov bl, [expressao_pos + ecx]
    add ecx, 1
    mov [i], ecx
    ;mov dl, bl
    ;mov byte [char_atual],dl
    ;imprima char_atual,1
    mov bh, '+'
    cmp bl,bh
    je soma
    ;mov byte [char_atual],'*'
    ;imprima [char_atual],1
    mov bh, '-'
    cmp bl,bh
    je subt
    mov bh, '*'
    cmp bl,bh
    je mult
    mov bh, '/'
    cmp bl,bh
    je divi
    movsx edx, bl
    ;----------------------------
    ;mov dl, bl
    ;mov byte [char_atual],dl
    ;imprima char_atual,1
    ;-----------------------------
    push edx
    ;inc ecx
    jmp check_operator
    
soma:
    ;mov dl, '='
    ;mov byte [char_atual],dl
    ;imprima char_atual,1
    pop ebx
    pop eax
    ;mov [i],ebx
    ;imprima i, 1
    sub ebx, '0'
    sub eax, '0'
    add eax, ebx
    add eax, '0'
    push eax
    jmp check_operator
subt:
    pop ebx
    pop eax
    sub ebx, '0'
    sub eax, '0'
    sub eax, ebx
    add eax, '0'
    push eax
    jmp check_operator
mult:
    pop ebx
    pop eax
    sub eax, '0'
    sub ebx, '0'
    mov ecx, 0
    mov edx, 0
    imul ebx
    add eax, '0'
    push eax
    jmp check_operator
divi:
    pop ebx
    pop eax
    sub eax, '0'
    sub ebx, '0'
    mov ecx, 0
    mov edx, 0
    idiv ebx
    add eax, '0'
    push eax
    jmp check_operator
    ;fim
    
o_fim2:
    pop eax
    ;add eax, '0'
    sub eax, '0'
    imprima msg_sem_erro, len2
    mov [i], eax
    mov al, 0xa             ; Move quebra de linha para o registrador al
    mov byte [char_atual], al
    imprima char_atual,1  ; Imprime quebra de linha
    
    ; -------------------
    ; Verifica se é positivo ou negativo
    cmp eax, 0
    jns positivo
    mov bl, '-'
    mov byte [char_atual], bl
    imprima char_atual, 1
    positivo:
    ; -------------------
    ; Laço para pegar todos os caracteres de um número inteiro
    mov ebx, 10 ; Inicializa o registrador ebx
    divide_por_dez: ; Vai dividindo por 10 até chegar em zero
    cmp eax, 0
    je exibe_resultado
    mov edx, 0 ; Zera o registrador
    div ebx
    push edx ; Empilha o resto das divisões por 10
    jmp divide_por_dez
    
    exibe_resultado:
    ;push edx
    mov edx, [topo_pilha]
    
    loop_resultado:
    cmp edx, esp
    je fim3
    pop eax
    add eax, '0'
    mov byte [char_atual], al
    imprima char_atual, 1
    jmp loop_resultado
    ;; -------------------
    ; Chamar a função de verificação da pilha
    ; Verificar reg esp
msg_error:
    imprima msg_com_erro, len1
    ;mov eax, 0xa
    ;mov [char_atual], eax
    ;imprima char_atual, 1
    jmp fim3
add_parenteses:
    ;o ebx já está zerado
    mov al, [expressao + ebx]
    add ebx, 1
    cmp al, 0xa ; Compara se é fim de linha
    jne add_parenteses
    
    sub ebx, 1
    mov al, ')'
    mov [expressao + ebx], al
    add ebx, 1
    mov al, 0xa
    mov [expressao + ebx], al
    mov ebx, 0x0 ; Zera o ebx
    jmp volta_inicio
fim3:
    fim
