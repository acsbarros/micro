extern printf
extern exit

section .data
    fmt db "%f", 10, 0
    sem_raizes db "No real roots", 10, 0
    
    a dq 1.0
    b dq -3.0
    c dq 2.0
    quatro dq 4.0
    dois dq 2.0
    zero dq 0.0
    menos1 dq -1.0      ; Constante para inverter sinal

section .bss
    resultado resq 1

section .text
    global main

main:
    push ebp
    mov ebp, esp
    
    ; Carregar coeficientes nos registradores SSE
    movsd xmm0, [b]      ; xmm0 = b (-3.0)
    movsd xmm1, [b]      ; xmm1 = b (-3.0)
    movsd xmm2, [a]      ; xmm2 = a (1.0)
    movsd xmm3, [c]      ; xmm3 = c (2.0)
    movsd xmm4, [quatro] ; xmm4 = 4.0
    movsd xmm5, [dois]   ; xmm5 = 2.0
    movsd xmm6, [zero]   ; xmm6 = 0.0

    ; Calcular delta = b*b - 4*a*c
    ; Passo 1: b*b
    movsd xmm7, xmm0     ; xmm7 = b
    mulsd xmm7, xmm1     ; xmm7 = b * b = 9.0
    
    ; Passo 2: 4*a*c
    movsd xmm0, xmm4     ; xmm0 = 4.0
    mulsd xmm0, xmm2     ; xmm0 = 4.0 * a = 4.0
    mulsd xmm0, xmm3     ; xmm0 = (4*a) * c = 8.0
    
    ; Passo 3: delta = b*b - 4*a*c
    subsd xmm7, xmm0     ; xmm7 = 9.0 - 8.0 = 1.0 (delta)
    
    ; Verificar se delta >= 0
    ucomisd xmm7, xmm6   ; compara delta com 0.0
    jb no_roots          ; se delta < 0, pula
    
    ; Calcular sqrt(delta)
    sqrtsd xmm7, xmm7    ; xmm7 = sqrt(1.0) = 1.0
    
    ; Primeira raiz: (-b + sqrt(delta)) / (2*a)
    ; Calcular -b
    movsd xmm0, [b]      ; xmm0 = -3.0
    mulsd xmm0, [menos1] ; xmm0 = -b = 3.0 (multiplica por -1)
    addsd xmm0, xmm7     ; xmm0 = -b + sqrt(delta) = 3.0 + 1.0 = 4.0
    
    ; Calcular denominador 2*a
    movsd xmm1, [dois]   ; xmm1 = 2.0
    mulsd xmm1, [a]      ; xmm1 = 2 * a = 2.0
    
    ; Dividir
    divsd xmm0, xmm1     ; xmm0 = 4.0 / 2.0 = 2.0
    
    ; Imprimir primeira raiz
    movsd [resultado], xmm0
    sub esp, 8
    movsd qword [esp], xmm0
    push fmt
    call printf
    add esp, 12
    
    ; Segunda raiz: (-b - sqrt(delta)) / (2*a)
    movsd xmm0, [b]      ; xmm0 = -3.0
    mulsd xmm0, [menos1] ; xmm0 = -b = 3.0
    subsd xmm0, xmm7     ; xmm0 = -b - sqrt(delta) = 3.0 - 1.0 = 2.0
    
    movsd xmm1, [dois]   ; xmm1 = 2.0
    mulsd xmm1, [a]      ; xmm1 = 2.0
    divsd xmm0, xmm1     ; xmm0 = 2.0 / 2.0 = 1.0
    
    ; Imprimir segunda raiz
    movsd [resultado], xmm0
    sub esp, 8
    movsd qword [esp], xmm0
    push fmt
    call printf
    add esp, 12
    
    jmp fim

no_roots:
    push sem_raizes
    call printf
    add esp, 4

fim:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret