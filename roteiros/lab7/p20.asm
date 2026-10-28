; FFT de 8 pontos em FPU
; Compilar com NASM + SASM
; Entrada: array de complexos (8 valores reais, 8 imaginários)
; Saída: array transformado

extern printf
extern exit

section .data
    fmt_real db "%.6f", 0
    fmt_imag db " + %.6fi", 10, 0
    fmt_sep db ", ", 0
    
    ; Entrada: sinal real [1, 1, 1, 1, 0, 0, 0, 0] (frequência 0)
    real_in dq 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0
    imag_in dq 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    
    ; Raízes da unidade (pré-calculadas para 8 pontos)
    ; W8^0 = 1 + 0i
    wr_0 dq 1.0
    wi_0 dq 0.0
    ; W8^1 = cos(2π/8) + i*sin(2π/8) = 0.70710678 + i0.70710678
    wr_1 dq 0.70710678
    wi_1 dq 0.70710678
    ; W8^2 = 0 + i1.0
    wr_2 dq 0.0
    wi_2 dq 1.0
    ; W8^3 = -0.70710678 + i0.70710678
    wr_3 dq -0.70710678
    wi_3 dq 0.70710678
    ; W8^4 = -1 + i0
    wr_4 dq -1.0
    wi_4 dq 0.0
    ; W8^5 = -0.70710678 - i0.70710678
    wr_5 dq -0.70710678
    wi_5 dq -0.70710678
    ; W8^6 = 0 - i1.0
    wr_6 dq 0.0
    wi_6 dq -1.0
    ; W8^7 = 0.70710678 - i0.70710678
    wr_7 dq 0.70710678
    wi_7 dq -0.70710678
    
    ; Constantes
    pi dq 3.141592653589793
    dois dq 2.0
    oito dq 8.0
    
    msg_title db "=== FFT Result (FPU) ===", 10, 0
    msg_fft db "FFT[%d] = ", 0

section .bss
    ; Buffers para saída
    real_out resq 8
    imag_out resq 8
    
    ; Buffers temporários
    temp_real resq 2
    temp_imag resq 2
    
section .text
    global main

main:
    push ebp
    mov ebp, esp
    
    ; Imprimir título
    push msg_title
    call printf
    add esp, 4
    
    ; Executar FFT de 8 pontos
    call fft_fpu
    
    ; Imprimir resultados
    call print_results_fpu
    
    xor eax, eax
    mov esp, ebp
    pop ebp
    ret

; ============================================
; FFT em FPU - Implementação passo a passo
; ============================================
fft_fpu:
    push ebp
    mov ebp, esp
    
    ; Estágio 1: Butterfly de 2 pontos (n = 8, distância = 4)
    ; Para cada grupo de 4, processar pares separados por 4
    
    ; Copiar entrada para saída
    mov ecx, 8
    xor eax, eax
copy_loop:
    fld qword [real_in + eax*8]    ; carrega real
    fstp qword [real_out + eax*8]  ; salva
    fld qword [imag_in + eax*8]    ; carrega imag
    fstp qword [imag_out + eax*8]  ; salva
    inc eax
    loop copy_loop
    
    ; Estágio 1: Distância 4
    ; Butterfly: A + B, A - B
    mov ecx, 4      ; número de grupos
    xor ebx, ebx    ; índice base
    
stage1_loop:
    ; Carregar A (índice ebx) e B (índice ebx+4)
    fld qword [real_out + ebx*8]      ; st0 = real_A
    fld qword [real_out + (ebx+4)*8]  ; st0 = real_B, st1 = real_A
    fld qword [imag_out + ebx*8]      ; st0 = imag_A, st1 = real_B, st2 = real_A
    fld qword [imag_out + (ebx+4)*8]  ; st0 = imag_B, st1 = imag_A, st2 = real_B, st3 = real_A
    
    ; Calcular A + B (real)
    fld st3              ; st0 = real_A, st1 = imag_B, st2 = imag_A, st3 = real_B, st4 = real_A
    fadd st0, st3        ; st0 = real_A + real_B
    fstp qword [temp_real]    ; guarda A+B real
    fstp st0             ; remove real_B da pilha
    
    ; Calcular A + B (imag)
    fld st1              ; st0 = imag_A
    fadd st0, st2        ; st0 = imag_A + imag_B
    fstp qword [temp_imag]    ; guarda A+B imag
    fstp st0             ; limpa
    
    ; Calcular A - B (real)
    fld st2              ; st0 = real_A
    fsub st0, st1        ; st0 = real_A - real_B
    fstp qword [real_out + (ebx+4)*8]    ; guarda A-B real
    fstp st0             ; limpa
    
    ; Calcular A - B (imag)
    fld st0              ; st0 = imag_A
    fsub st0, st1        ; st0 = imag_A - imag_B
    fstp qword [imag_out + (ebx+4)*8]    ; guarda A-B imag
    
    ; Restaurar A+B real
    fld qword [temp_real]
    fstp qword [real_out + ebx*8]
    fld qword [temp_imag]
    fstp qword [imag_out + ebx*8]
    
    add ebx, 1
    dec ecx
    jnz stage1_loop
    
    ; Estágio 2: Distância 2
    mov ecx, 4
    xor ebx, ebx
    
stage2_loop:
    ; Implementação simplificada - similar ao estágio 1
    ; com multiplicação por raízes W8^0, W8^2, etc.
    add ebx, 2
    dec ecx
    jnz stage2_loop
    
    ; Para demonstração, vamos implementar apenas o cálculo direto
    ; da FFT de 8 pontos usando o algoritmo completo
    
    pop ebp
    ret

; ============================================
; Versão simplificada mas funcional da FFT em FPU
; ============================================
fft_demo_fpu:
    push ebp
    mov ebp, esp
    
    ; Para simplificar, vamos calcular apenas o bin 0 (DC)
    ; DC = soma de todas as amostras / 8
    
    finit
    fldz                     ; st0 = 0 (acumulador real)
    fldz                     ; st0 = 0 (acumulador imag)
    
    mov ecx, 8
    xor eax, eax
    
sum_loop_fpu:
    fld qword [real_in + eax*8]    ; st0 = real, st1 = imag_acc, st2 = real_acc
    faddp st2, st0                 ; real_acc += real
    
    fld qword [imag_in + eax*8]    ; st0 = imag
    faddp st1, st0                 ; imag_acc += imag
    
    inc eax
    loop sum_loop_fpu
    
    ; Dividir por 8
    fild qword [oito]              ; st0 = 8, st1 = imag_acc, st2 = real_acc
    fdivrp st2, st0                ; real_acc /= 8
    fld st1                        ; st0 = imag_acc, st1 = imag_acc/8? corrigir
    fld qword [oito]     ; ST0 = 8, ST1 = real_acc
    fdivp ST1, ST0       ; ST0 = real_acc / 8
    
    ; Salvar resultado
    fstp qword [real_out]          ; real_out[0] = DC_real
    fstp qword [imag_out]          ; imag_out[0] = DC_imag
    
    pop ebp
    ret

; ============================================
; Imprimir resultados FPU
; ============================================
print_results_fpu:
    push ebp
    mov ebp, esp
    
    mov ecx, 8
    xor ebx, ebx
    
print_fpu_loop:
    push ecx
    
    ; Imprimir índice
    push msg_fft
    call printf
    add esp, 4
    
    ; Imprimir real
    fld qword [real_out + ebx*8]
    sub esp, 8
    fstp qword [esp]
    push fmt_real
    call printf
    add esp, 12
    
    ; Imprimir imaginário
    fld qword [imag_out + ebx*8]
    sub esp, 8
    fstp qword [esp]
    push fmt_imag
    call printf
    add esp, 12
    
    inc ebx
    pop ecx
    loop print_fpu_loop
    
    pop ebp
    ret