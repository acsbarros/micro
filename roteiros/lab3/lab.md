Laboratório Prático: MOVZX vs MOVSX com Valores Octais
Objetivo
Compreender na prática a diferença entre extensão com zero (MOVZX) e extensão com sinal (MOVSX) usando valores octais no NASM.

Pré-requisitos
Linux (Ubuntu/Debian recomendado)

NASM instalado: sudo apt install nasm

GDB (debugger): sudo apt install gdb

Editor de texto (vim, nano, VSCode)

Experimento 1: Comparação Básica
Passo 1: Criar o programa
Crie o arquivo comparacao.asm:

section .data
    ; Valores octais para teste
    val_positivo db 177o      ; 127 decimal (bit7=0)
    val_limite   db 200o      ; 128 decimal (bit7=1)
    val_negativo db 377o      ; 255 decimal (bit7=1)
    
    newline db 10
    
section .bss
    buffer resb 16

section .text
    global _start

_start:
    ; TESTE 1: Valor positivo (177o)
    mov al, [val_positivo]
    movzx ecx, al           ; ECX = extensão com zero
    movsx edx, al           ; EDX = extensão com sinal
    
    ; TESTE 2: Valor limite (200o)
    mov al, [val_limite]
    movzx esi, al
    movsx edi, al
    
    ; TESTE 3: Valor negativo (377o)
    mov al, [val_negativo]
    movzx r8d, al
    movsx r9d, al
    
    ; Exit point para debug
    mov eax, 60             ; syscall exit
    xor edi, edi
    syscall


Passo 2: Compilar e linkar
nasm -f elf64 comparacao.asm -o comparacao.o
ld comparacao.o -o comparacao
Passo 3: Analisar com GDB
gdb ./comparacao

Comandos dentro do GDB:

# Colocar breakpoint no exit
break _start
run

# Ver registradores após cada teste
info registers

# Ou ver registradores específicos
p/x $ecx    # MOVZX do 177o (deveria ser 0x7f)
p/x $edx    # MOVSX do 177o (deveria ser 0x7f)
p/x $esi    # MOVZX do 200o (deveria ser 0x80)
p/x $edi    # MOVSX do 200o (deveria ser 0xffffff80)
p/d $edi    # Ver como decimal signed (deveria ser -128)

# Para sair do GDB
quit

Experimento 2: Programa Interativo com Saída
Passo 4: Criar programa com impressão de resultados
Crie o arquivo laboratorio.asm:

section .data
    titulo db "=== LABORATORIO MOVZX vs MOVSX ===", 10, 0
    titulo_len equ $ - titulo
    
    msg1 db "Teste 1: Valor Octal 177 (127 decimal)", 10, 0
    msg1_len equ $ - msg1
    
    msg2 db "Teste 2: Valor Octal 200 (128 decimal)", 10, 0
    msg2_len equ $ - msg2
    
    msg3 db "Teste 3: Valor Octal 377 (255 decimal)", 10, 0
    msg3_len equ $ - msg3
    
    fmt_movzx db "  MOVZX: %u decimal (0x%x)", 10, 0
    fmt_movsx db "  MOVSX: %d decimal (0x%x)", 10, 0
    
    separador db "------------------------", 10, 0
    sep_len equ $ - separador

section .bss
    buffer resb 32

section .text
    extern printf
    global main

main:
    push rbp
    mov rbp, rsp
    
    ; Imprime título
    mov rdi, titulo
    call printf
    
    ; ===== TESTE 1: 177o = 127 = 0x7F = bit7=0 =====
    mov rdi, msg1
    call printf
    
    mov al, 177o                    ; 127 decimal
    movzx esi, al                   ; ESI = 127 (unsigned)
    mov edx, esi                    ; EDX = valor para MOVZX
    mov ecx, esi                    ; ECX = valor para hex
    
    mov rdi, fmt_movzx
    call printf
    
    mov al, 177o
    movsx esi, al                   ; ESI = 127 (signed)
    mov edx, esi
    mov ecx, esi
    mov rdi, fmt_movsx
    call printf
    
    ; ===== TESTE 2: 200o = 128 = 0x80 = bit7=1 =====
    mov rdi, msg2
    call printf
    
    mov al, 200o                    ; 128 decimal
    movzx esi, al                   ; ESI = 128 (unsigned)
    mov edx, esi
    mov ecx, esi
    mov rdi, fmt_movzx
    call printf
    
    mov al, 200o
    movsx esi, al                   ; ESI = -128 (signed)
    mov edx, esi
    mov ecx, esi
    mov rdi, fmt_movsx
    call printf
    
    ; ===== TESTE 3: 377o = 255 = 0xFF = bit7=1 =====
    mov rdi, msg3
    call printf
    
    mov al, 377o                    ; 255 decimal
    movzx esi, al                   ; ESI = 255 (unsigned)
    mov edx, esi
    mov ecx, esi
    mov rdi, fmt_movzx
    call printf
    
    mov al, 377o
    movsx esi, al                   ; ESI = -1 (signed)
    mov edx, esi
    mov ecx, esi
    mov rdi, fmt_movsx
    call printf
    
    ; Separador final
    mov rdi, separador
    call printf
    
    mov rsp, rbp
    pop rbp
    ret


Passo 5: Compilar com printf (link dinâmico)

nasm -f elf64 laboratorio.asm -o laboratorio.o
gcc laboratorio.o -o laboratorio -no-pie
./laboratorio

Saída esperada:

=== LABORATORIO MOVZX vs MOVSX ===
Teste 1: Valor Octal 177 (127 decimal)
  MOVZX: 127 decimal (0x7f)
  MOVSX: 127 decimal (0x7f)
Teste 2: Valor Octal 200 (128 decimal)
  MOVZX: 128 decimal (0x80)
  MOVSX: -128 decimal (0xffffff80)
Teste 3: Valor Octal 377 (255 decimal)
  MOVZX: 255 decimal (0xff)
  MOVSX: -1 decimal (0xffffffff)
------------------------

Experimento 3: Desafios Práticos
Desafio 1: Conversor de Temperatura
Crie temperatura.asm:

section .data
    ; Temperaturas em octal (formato signed 8 bits)
    temp_sensor1 db 200o      ; -128°C (muito frio)
    temp_sensor2 db 0o        ; 0°C
    temp_sensor3 db 177o      ; 127°C (muito quente)
    
    msg_temp db "Temperatura do sensor: %d°C", 10, 0

section .text
    extern printf
    global main

main:
    push rbp
    mov rbp, rsp
    
    ; Sensor 1 - deve usar MOVSX para valor correto
    mov al, [temp_sensor1]
    movsx esi, al               ; ESI = -128 (correto!)
    mov rdi, msg_temp
    call printf
    
    ; Sensor 2
    mov al, [temp_sensor2]
    movsx esi, al               ; ESI = 0
    mov rdi, msg_temp
    call printf
    
    ; Sensor 3
    mov al, [temp_sensor3]
    movsx esi, al               ; ESI = 127
    mov rdi, msg_temp
    call printf
    
    pop rbp
    ret


Pergunta: O que aconteceria se usássemos MOVZX no sensor 1? Teste e explique.

Desafio 2: Processamento de Cores RGB
Crie rgb.asm:

section .data
    ; Cores em octal (valores unsigned 0-255)
    cor_vermelho db 377o      ; 255 (vermelho máximo)
    cor_verde    db 200o      ; 128 (verde médio)
    cor_azul     db 0o        ; 0 (sem azul)
    
    msg_rgb db "R:%d G:%d B:%d", 10, 0

section .text
    extern printf
    global main

main:
    push rbp
    mov rbp, rsp
    
    ; Para RGB, devemos usar MOVZX (valores unsigned!)
    mov al, [cor_vermelho]
    movzx esi, al               ; R = 255
    
    mov al, [cor_verde]
    movzx edx, al               ; G = 128
    
    mov al, [cor_azul]
    movzx ecx, al               ; B = 0
    
    mov rdi, msg_rgb
    call printf
    
    pop rbp
    ret


Pergunta: Por que usar MOVSX nas cores RGB daria resultado errado?

Desafio 3: Calculadora de Permissões UNIX
Crie permissoes.asm:

section .data
    ; Permissões em octal
    arquivo1 db 0o755     ; rwxr-xr-x
    arquivo2 db 0o644     ; rw-r--r--
    arquivo3 db 0o000     ; ---------
    
    msg_perm db "Permissão: %03o (decimal: %u)", 10, 0

section .text
    extern printf
    global main

main:
    push rbp
    mov rbp, rsp
    
    ; Arquivo 1
    mov al, [arquivo1]
    movzx esi, al               ; Para octal, usar unsigned
    mov edx, esi                ; Mesmo valor para decimal
    mov rdi, msg_perm
    call printf
    
    ; Arquivo 2
    mov al, [arquivo2]
    movzx esi, al
    mov edx, esi
    mov rdi, msg_perm
    call printf
    
    ; Arquivo 3
    mov al, [arquivo3]
    movzx esi, al
    mov edx, esi
    mov rdi, msg_perm
    call printf
    
    pop rbp
    ret


Questionário do Laboratório
Responda após realizar os experimentos:

Quando MOVZX e MOVSX produzem o mesmo resultado? Por quê?

Qual instrução deve ser usada para valores que podem ser negativos? Justifique.

Converta os seguintes octais para decimal e determine se MOVZX ou MOVSX é apropriado:

0o100 (64 decimal)

0o300 (192 decimal)

0o177 (127 decimal)

0o200 (128 decimal)

Analise o erro: Por que o código abaixo produz saída incorreta?

mov al, 200o    ; Sensor de temperatura -40°C armazenado como 0xD8
movzx eax, al   ; EAX = 216 (errado! deveria ser -40)

Desafio extra: Escreva um programa que leia um valor octal do usuário e use a instrução correta baseada no contexto (signed vs unsigned).

Respostas Esperadas
Resposta 1:
MOVZX e MOVSX produzem o mesmo resultado quando o bit mais significativo (bit7) do byte fonte é 0, ou seja, quando o valor está entre 0 e 127 decimal (0 a 177 octal).

Resposta 2:
MOVSX deve ser usado para valores signed (que podem ser negativos). MOVZX para valores unsigned.

Resposta 3:
0o100 = 64 → MOVZX ou MOVSX (ambos 64)

0o300 = 192 → MOVZX (192 como unsigned) ou MOVSX (-64 como signed)

0o177 = 127 → ambos

0o200 = 128 → MOVZX (128) ou MOVSX (-128)

Resposta 4:
O erro está usando MOVZX em vez de MOVSX. O valor 0xD8 (octal 330) tem bit7=1, então MOVZX trata como 216 (unsigned) quando deveria ser -40 com MOVSX.

Entrega do Laboratório
Para concluir o laboratório, entregue:

Screenshot da execução do laboratorio.asm

Respostas do questionário

Código dos 3 desafios resolvidos

Explicação de um caso real onde a escolha errada causaria bug

