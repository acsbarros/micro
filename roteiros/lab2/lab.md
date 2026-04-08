**Roteiro da Segunda Prática - Registrador EFLAGS**
**Laboratório 2:** Compreendendo o Registrador EFLAGS
**Disciplina:** Microprocessadores 8086/8088
**Professor:** Carlos Barros - UNILAB
**Duração:** 2 horas

## 🎯 Objetivos da Prática

Ao final desta prática, o aluno será capaz de:

Compreender a estrutura e propósito do registrador EFLAGS (32 bits) e FLAGS (16 bits)

Identificar e interpretar as flags mais importantes (CF, PF, AF, ZF, SF, TF, IF, DF, OF)

Prever o estado das flags após operações aritméticas e lógicas

Utilizar as flags para tomada de decisão em programas assembly

Visualizar as flags em tempo real usando o debugger do SASM


## 📚 Fundamentos Teóricos
1. O Registrador FLAGS (16 bits) / EFLAGS (32 bits)
O registrador EFLAGS é um registrador de 32 bits onde cada bit representa uma flag (bandeira) que indica o estado do processador ou o resultado da última operação.

```text
EFLAGS (32 bits) - Processadores 386+
├── FLAGS (16 bits baixos) - Compatível com 8086/8088
    ├── Bits de status (afetados por operações)
    │   ├── CF (bit 0) - Carry Flag
    │   ├── PF (bit 2) - Parity Flag
    │   ├── AF (bit 4) - Auxiliary Flag
    │   ├── ZF (bit 6) - Zero Flag
    │   ├── SF (bit 7) - Sign Flag
    │   └── OF (bit 11) - Overflow Flag
    └── Bits de controle
        ├── TF (bit 8) - Trap Flag
        ├── IF (bit 9) - Interrupt Flag
        └── DF (bit 10) - Direction Flag
```

2. Tabela Completa de Flags
Flag	Bit	Nome	Descrição	Afetado por
CF	0	Carry Flag	Indica carry/borrow em operações sem sinal	ADD, SUB, SHL, SHR, MUL, DIV
PF	2	Parity Flag	1 se o byte baixo do resultado tem número par de bits 1	Operações lógicas e aritméticas
AF	4	Auxiliary Flag	Carry do bit 3 para o bit 4 (usado em BCD)	ADD, SUB (operações BCD)
ZF	6	Zero Flag	1 se resultado for zero	Todas operações
SF	7	Sign Flag	1 se resultado for negativo (bit mais significativo = 1)	Todas operações
TF	8	Trap Flag	Modo single-step (debug)	Instrução INT 01h
IF	9	Interrupt Flag	Habilita/desabilita interrupções	STI, CLI
DF	10	Direction Flag	Direção das operações com string (0=incrementar, 1=decrementar)	CLD, STD
OF	11	Overflow Flag	Indica overflow em operações com sinal	ADD, SUB, MUL
3. Estrutura Visual do EFLAGS (16 bits baixos - FLAGS)

```text
Bit:   15  14  13  12  11  10  9   8   7   6   5   4   3   2   1   0
      ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
      │   │   │   │   │ O │ D │ I │ T │ S │ Z │   │ A │   │ P │   │ C │
      │   │   │   │   │ F │ F │ F │ F │ F │ F │   │ F │   │ F │   │ F │
      └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
        0   0   0   0   11  10  9   8   7   6   5   4   3   2   1   0
```

4. Como Ler as Flags
No debugger do SASM, as flags aparecem como:

```text
EFLAGS: 0000000000000011  (valor hexa)
OU
Flags: CF=0 PF=0 AF=0 ZF=0 SF=0 OF=0
```

## 🛠️ Materiais Necessários
Computador com Linux (ou VM)
NASM e SASM instalados
Acesso ao terminal
Debugger do SASM (F7)

## 📝 Exercícios Práticos
Exercício 1: Visualizando o EFLAGS no SASM
Objetivo: Aprender a observar as flags em tempo real usando o debugger.

Código: visualiza_flags.asm
```assembly
%include "io.inc"

section .data
    msg_titulo db '=== Estudo do Registrador EFLAGS ===', 0
    msg_cf db 'Carry Flag (CF) - Indicador de carry/borrow', 0
    msg_zf db 'Zero Flag (ZF) - Resultado igual a zero', 0
    msg_sf db 'Sign Flag (SF) - Resultado negativo', 0
    msg_of db 'Overflow Flag (OF) - Overflow em sinal', 0
    msg_pf db 'Parity Flag (PF) - Paridade par', 0
    msg_df db 'Direction Flag (DF) - Direção de strings', 0
    msg_if db 'Interrupt Flag (IF) - Interrupções', 0
    linha db '----------------------------------------', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; Exibir informações
    PRINT_STRING msg_titulo
    NEWLINE
    PRINT_STRING linha
    NEWLINE
    PRINT_STRING msg_cf
    NEWLINE
    PRINT_STRING msg_zf
    NEWLINE
    PRINT_STRING msg_sf
    NEWLINE
    PRINT_STRING msg_of
    NEWLINE
    PRINT_STRING msg_pf
    NEWLINE
    PRINT_STRING msg_df
    NEWLINE
    PRINT_STRING msg_if
    NEWLINE
    PRINT_STRING linha
    NEWLINE
    
    ; PONTO DE PARADA 1 - Coloque breakpoint aqui
    ; Estado inicial das flags
    
    ; Operação que afeta CF
    mov al, 0xFF
    add al, 1        ; Deve ativar CF
    
    ; PONTO DE PARADA 2 - Observe CF=1
    
    ; Operação que afeta ZF
    mov al, 0x05
    sub al, 0x05     ; Resultado zero
    
    ; PONTO DE PARADA 3 - Observe ZF=1
    
    ; Operação que afeta SF
    mov al, 0x80     ; -128 em sinal
    add al, 0x00     ; Mantém negativo
    
    ; PONTO DE PARADA 4 - Observe SF=1
    
    ; Operação que afeta OF
    mov al, 0x7F     ; 127 em sinal
    add al, 0x01     ; 128 -> overflow
    
    ; PONTO DE PARADA 5 - Observe OF=1
    
    ; Operação que afeta PF (paridade)
    mov al, 0x03     ; 00000011 (2 bits 1 - par)
    ; PF será 1 (par)
    
    ; PONTO DE PARADA 6 - Observe PF=1
    
    ; Manipulando DF
    CLD              ; Clear Direction Flag (DF=0)
    STD              ; Set Direction Flag (DF=1)
    
    ; PONTO DE PARADA 7 - Observe DF=1
    
    ; Manipulando IF (precisa de privilégio)
    ; STI - Set Interrupt Flag (habilita interrupções)
    ; CLI - Clear Interrupt Flag (desabilita)
    
    xor eax, eax
    ret
```

Procedimento no SASM:

Copie o código no SASM

Pressione F7 para iniciar debug

Adicione breakpoints clicando nas linhas dos "PONTO DE PARADA"

Execute com F8 e observe o painel Registers

Anote os valores das flags após cada operação

Exercício 2: Carry Flag (CF) - Transporte e Empréstimo
Objetivo: Entender quando a Carry Flag é ativada em operações sem sinal.

Código: carry_flag.asm

```assembly
%include "io.inc"

section .data
    msg_cf0 db 'CF=0 - Operação normal', 0
    msg_cf1 db 'CF=1 - Ocorreu carry/borrow!', 0
    msg_add db 'Soma: ', 0
    msg_sub db 'Subtração: ', 0
    newline db 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; ==========================================
    ; CASO 1: Soma sem carry (8 bits)
    ; ==========================================
    PRINT_STRING msg_add
    NEWLINE
    
    mov al, 100
    add al, 50      ; 100 + 50 = 150 (<255)
    
    ; Verificando CF
    jc carry_ativado1
    PRINT_STRING msg_cf0
    NEWLINE
    jmp prox1
carry_ativado1:
    PRINT_STRING msg_cf1
    NEWLINE
prox1:
    
    ; ==========================================
    ; CASO 2: Soma COM carry (8 bits)
    ; ==========================================
    mov al, 200
    add al, 100     ; 200 + 100 = 300 (>255)
    
    jc carry_ativado2
    PRINT_STRING msg_cf0
    NEWLINE
    jmp prox2
carry_ativado2:
    PRINT_STRING msg_cf1
    NEWLINE
    PRINT_STRING msg_add
    NEWLINE
    PRINT_DEC 1, al    ; Mostra resultado truncado
    NEWLINE
prox2:
    
    ; ==========================================
    ; CASO 3: Subtração sem borrow
    ; ==========================================
    PRINT_STRING msg_sub
    NEWLINE
    
    mov al, 50
    sub al, 30      ; 50 - 30 = 20 (>=0)
    
    jc borrow_ativado1
    PRINT_STRING msg_cf0
    NEWLINE
    jmp prox3
borrow_ativado1:
    PRINT_STRING msg_cf1
    NEWLINE
prox3:
    
    ; ==========================================
    ; CASO 4: Subtração COM borrow
    ; ==========================================
    mov al, 10
    sub al, 20      ; 10 - 20 = -10 (precisa borrow)
    
    jc borrow_ativado2
    PRINT_STRING msg_cf0
    NEWLINE
    jmp prox4
borrow_ativado2:
    PRINT_STRING msg_cf1
    NEWLINE
    PRINT_STRING msg_sub
    NEWLINE
    PRINT_DEC 1, al    ; Mostra resultado (complemento de 2)
    NEWLINE
prox4:
    
    xor eax, eax
    ret
```

Questões:

Qual o valor em AL após 200 + 100? Por que?

O que CF indica em uma subtração?

Como podemos usar CF para detectar números negativos em sem sinal?

Exercício 3: Zero Flag (ZF) e Sign Flag (SF)
Objetivo: Entender como ZF e SF indicam igualdade e sinal do resultado.

Código: zero_sign_flag.asm
```assembly
%include "io.inc"

section .data
    msg_zf_ativo db 'ZF=1 - Resultado é ZERO', 0
    msg_zf_inativo db 'ZF=0 - Resultado NÃO é zero', 0
    msg_sf_ativo db 'SF=1 - Resultado NEGATIVO', 0
    msg_sf_inativo db 'SF=0 - Resultado POSITIVO', 0
    msg_comparacao db 'Comparando valores...', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; ==========================================
    ; Teste 1: ZF ativado
    ; ==========================================
    mov al, 10
    sub al, 10      ; 10 - 10 = 0
    
    PRINT_STRING msg_comparacao
    NEWLINE
    
    jz zero_ativado1
    PRINT_STRING msg_zf_inativo
    NEWLINE
    jmp sf_teste1
zero_ativado1:
    PRINT_STRING msg_zf_ativo
    NEWLINE
    
sf_teste1:
    ; Verificando SF (resultado positivo/negativo)
    js sinal_negativo1
    PRINT_STRING msg_sf_inativo
    NEWLINE
    jmp teste2
sinal_negativo1:
    PRINT_STRING msg_sf_ativo
    NEWLINE
    
    ; ==========================================
    ; Teste 2: SF ativado (resultado negativo)
    ; ==========================================
teste2:
    mov al, 5
    sub al, 10      ; 5 - 10 = -5
    
    PRINT_STRING msg_comparacao
    NEWLINE
    
    jz zero_ativado2
    PRINT_STRING msg_zf_inativo
    NEWLINE
    jmp sf_teste2
zero_ativado2:
    PRINT_STRING msg_zf_ativo
    NEWLINE
    
sf_teste2:
    js sinal_negativo2
    PRINT_STRING msg_sf_inativo
    NEWLINE
    jmp teste3
sinal_negativo2:
    PRINT_STRING msg_sf_ativo
    NEWLINE
    
    ; ==========================================
    ; Teste 3: Comparação entre valores (CMP)
    ; ==========================================
teste3:
    PRINT_STRING msg_comparacao
    NEWLINE
    
    mov al, 15
    cmp al, 10      ; Compara AL com 10
    
    ; CMP é como SUB mas não altera operandos, só flags
    jg maior        ; Jump if Greater (ZF=0 e SF=OF)
    je igual        ; Jump if Equal (ZF=1)
    jl menor        ; Jump if Less (SF != OF)
    
maior:
    PRINT_STRING msg_zf_inativo
    NEWLINE
    PRINT_STRING msg_sf_inativo
    NEWLINE
    jmp fim
    
igual:
    PRINT_STRING msg_zf_ativo
    NEWLINE
    jmp fim
    
menor:
    PRINT_STRING msg_zf_inativo
    NEWLINE
    PRINT_STRING msg_sf_ativo
    NEWLINE
    
fim:
    xor eax, eax
    ret
```
Questões:

O que acontece com ZF quando o resultado é zero?

Como SF se comporta para números negativos?

Qual a diferença entre SUB e CMP?

Exercício 4: Overflow Flag (OF) - A Mais Complexa
Objetivo: Compreender a Overflow Flag e sua relação com números com sinal.

Código: overflow_flag.asm

```assembly
%include "io.inc"

section .data
    msg_of_ativado db 'OVERFLOW! Resultado não cabe em sinal', 0
    msg_of_normal db 'Sem overflow - operação OK', 0
    msg_valor db 'Resultado: ', 0
    newline db 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    PRINT_STRING msg_valor
    NEWLINE
    
    ; ==========================================
    ; CASO 1: Soma que NÃO causa overflow
    ; 50 + 30 = 80 (dentro da faixa -128 a 127)
    ; ==========================================
    mov al, 50
    add al, 30
    
    jo overflow1    ; Jump if Overflow
    
    PRINT_STRING msg_of_normal
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    jmp caso2
    
overflow1:
    PRINT_STRING msg_of_ativado
    NEWLINE
    
    ; ==========================================
    ; CASO 2: Soma que CAUSA overflow
    ; 100 + 50 = 150 ( > 127)
    ; ==========================================
caso2:
    mov al, 100
    add al, 50
    
    jo overflow2
    
    PRINT_STRING msg_of_normal
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    jmp caso3
    
overflow2:
    PRINT_STRING msg_of_ativado
    NEWLINE
    PRINT_DEC 1, al    ; Mostra o valor incorreto (overflow)
    NEWLINE
    
    ; ==========================================
    ; CASO 3: Soma de negativos que causa overflow
    ; -100 + (-50) = -150 ( < -128)
    ; ==========================================
caso3:
    mov al, -100      ; 0x9C em hexa
    add al, -50       ; 0xCE em hexa
    
    jo overflow3
    
    PRINT_STRING msg_of_normal
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    jmp caso4
    
overflow3:
    PRINT_STRING msg_of_ativado
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    
    ; ==========================================
    ; CASO 4: OF vs CF - Diferença fundamental
    ; ==========================================
caso4:
    PRINT_STRING msg_valor
    NEWLINE
    
    ; Exemplo: 0xFF + 1
    ; Sem sinal: 255 + 1 = 256 -> CF=1, OF=0
    ; Com sinal: -1 + 1 = 0 -> CF=1, OF=0
    
    mov al, 0xFF
    add al, 1
    
    jc carry_ativado
    PRINT_STRING 'CF=0 '
    jmp of_test
carry_ativado:
    PRINT_STRING 'CF=1 '
    
of_test:
    jo of_ativado
    PRINT_STRING 'OF=0'
    NEWLINE
    jmp fim
of_ativado:
    PRINT_STRING 'OF=1'
    NEWLINE
    
fim:
    xor eax, eax
    ret
```

Tabela para preencher:

Operação	Decimal (sinal)	Resultado	OF	CF	Explicação
50 + 30	50 + 30 = 80	80			
100 + 50	100 + 50 = 150				
-100 + (-50)	-150				
0xFF + 1	-1 + 1 = 0	0

Exercício 5: Parity Flag (PF) - Paridade do Resultado
Objetivo: Entender a flag de paridade e sua utilidade.

Código: parity_flag.asm

```assembly
%include "io.inc"

section .data
    msg_par db 'Paridade PAR (PF=1) - Número par de bits 1', 0
    msg_impar db 'Paridade ÍMPAR (PF=0) - Número ímpar de bits 1', 0
    msg_bits db 'Bits do resultado: ', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; ==========================================
    ; Teste 1: 0x03 (00000011) - 2 bits 1 -> PAR
    ; ==========================================
    mov al, 0x03
    add al, 0x00    ; Mantém 0x03
    
    PRINT_STRING msg_bits
    NEWLINE
    ; Exibir em binário (simplificado)
    PRINT_STRING '00000011'
    NEWLINE
    
    jp paridade_par1
    PRINT_STRING msg_impar
    NEWLINE
    jmp teste2
paridade_par1:
    PRINT_STRING msg_par
    NEWLINE
    
    ; ==========================================
    ; Teste 2: 0x01 (00000001) - 1 bit 1 -> ÍMPAR
    ; ==========================================
teste2:
    mov al, 0x01
    
    PRINT_STRING msg_bits
    NEWLINE
    PRINT_STRING '00000001'
    NEWLINE
    
    jp paridade_par2
    PRINT_STRING msg_impar
    NEWLINE
    jmp teste3
paridade_par2:
    PRINT_STRING msg_par
    NEWLINE
    
    ; ==========================================
    ; Teste 3: 0x55 (01010101) - 4 bits 1 -> PAR
    ; ==========================================
teste3:
    mov al, 0x55
    
    PRINT_STRING msg_bits
    NEWLINE
    PRINT_STRING '01010101'
    NEWLINE
    
    jp paridade_par3
    PRINT_STRING msg_impar
    NEWLINE
    jmp teste4
paridade_par3:
    PRINT_STRING msg_par
    NEWLINE
    
    ; ==========================================
    ; Teste 4: Resultado de operação
    ; ==========================================
teste4:
    mov al, 0x0F    ; 00001111 (4 bits 1 - PAR)
    add al, 0x01    ; 00010000 (1 bit 1 - ÍMPAR)
    
    PRINT_STRING msg_bits
    NEWLINE
    PRINT_STRING '00010000'
    NEWLINE
    
    jp paridade_par4
    PRINT_STRING msg_impar
    NEWLINE
    jmp fim
paridade_par4:
    PRINT_STRING msg_par
    NEWLINE
    
fim:
    xor eax, eax
    ret
```

Questões:

Quantos bits 1 tem o número 0xAA? Qual será PF?

Qual a utilidade prática da flag de paridade?

PF considera quantos bits do resultado?

Exercício 6: Direction Flag (DF) e String Operations
Objetivo: Entender como DF controla operações com strings.

Código: direction_flag.asm

```assembly
%include "io.inc"

section .data
    fonte db 'ABCDEF', 0
    destino db '......', 0
    msg_antes db 'Antes: ', 0
    msg_depois db 'Depois: ', 0
    msg_cld db 'CLD - DF=0 (incrementa)', 0
    msg_std db 'STD - DF=1 (decrementa)', 0

section .bss
    buffer resb 7

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; ==========================================
    ; Demonstrando CLD (Clear Direction Flag)
    ; DF=0 -> MOVSB incrementa SI e DI
    ; ==========================================
    PRINT_STRING msg_cld
    NEWLINE
    
    CLD                 ; DF = 0
    
    mov esi, fonte
    mov edi, destino
    mov ecx, 6
    rep movsb           ; Copia 6 bytes de fonte para destino
    
    PRINT_STRING msg_depois
    NEWLINE
    PRINT_STRING destino
    NEWLINE
    
    ; ==========================================
    ; Demonstrando STD (Set Direction Flag)
    ; DF=1 -> MOVSB decrementa SI e DI
    ; ==========================================
    PRINT_STRING msg_std
    NEWLINE
    
    STD                 ; DF = 1
    
    ; Reinicializar
    mov byte [destino], '.'
    mov byte [destino+1], '.'
    mov byte [destino+2], '.'
    mov byte [destino+3], '.'
    mov byte [destino+4], '.'
    mov byte [destino+5], '.'
    
    mov esi, fonte+5    ; Começa do final
    mov edi, destino+5
    mov ecx, 6
    rep movsb           ; Copia ao contrário
    
    PRINT_STRING msg_depois
    NEWLINE
    PRINT_STRING destino
    NEWLINE
    
    xor eax, eax
    ret
```
Questões:

Qual a diferença entre CLD e STD?

Para que serve a instrução REP MOVSB?

Como DF afeta a direção da cópia?

Exercício 7: Aplicação Prática - Tomada de Decisão
Objetivo: Usar múltiplas flags para controle de fluxo.

Código: decisao_flags.asm

```assembly
%include "io.inc"

section .data
    msg_num1 db 'Primeiro número: ', 0
    msg_num2 db 'Segundo número: ', 0
    msg_resultado db 'Resultado: ', 0
    msg_maior db ' é maior que ', 0
    msg_menor db ' é menor que ', 0
    msg_igual db ' é igual a ', 0
    msg_overflow db 'ATENÇÃO: Overflow detectado!', 0
    newline db 0

section .bss
    num1 resb 1
    num2 resb 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; Simulando valores
    mov byte [num1], 100
    mov byte [num2], 50
    
    ; ==========================================
    ; Comparação com sinal
    ; ==========================================
    mov al, [num1]
    cmp al, [num2]
    
    je sao_iguais
    jg primeiro_maior
    jl primeiro_menor
    
sao_iguais:
    PRINT_DEC 1, [num1]
    PRINT_STRING msg_igual
    PRINT_DEC 1, [num2]
    NEWLINE
    jmp operacao
    
primeiro_maior:
    PRINT_DEC 1, [num1]
    PRINT_STRING msg_maior
    PRINT_DEC 1, [num2]
    NEWLINE
    jmp operacao
    
primeiro_menor:
    PRINT_DEC 1, [num1]
    PRINT_STRING msg_menor
    PRINT_DEC 1, [num2]
    NEWLINE
    
    ; ==========================================
    ; Operação com verificação de overflow
    ; ==========================================
operacao:
    PRINT_STRING msg_resultado
    NEWLINE
    
    mov al, [num1]
    add al, [num2]
    
    jo overflow_ocorreu
    
    ; Sem overflow
    PRINT_DEC 1, al
    NEWLINE
    jmp fim
    
overflow_ocorreu:
    PRINT_STRING msg_overflow
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    PRINT_STRING ' (resultado truncado devido a overflow)'
    NEWLINE
    
fim:
    xor eax, eax
    ret

```
Desafio: Modifique o programa para:

Verificar também Carry Flag (CF) em operações sem sinal

Mostrar o estado de todas as flags após a operação

Tomar decisões diferentes baseadas em CF e OF

🧪 Laboratório Avançado: Detector de Flags
Desafio Final: Crie um programa que seja um "Detector de Flags" interativo.

Código base: detector_flags.asm

```assembly
%include "io.inc"

section .data
    menu db '=== DETECTOR DE FLAGS EFLAGS ===', 0xa
         db '1 - Testar Carry Flag (CF)', 0xa
         db '2 - Testar Zero Flag (ZF)', 0xa
         db '3 - Testar Sign Flag (SF)', 0xa
         db '4 - Testar Overflow Flag (OF)', 0xa
         db '5 - Testar Parity Flag (PF)', 0xa
         db '6 - Testar Direction Flag (DF)', 0xa
         db '7 - Mostrar todas as flags', 0xa
         db '0 - Sair', 0xa
         db 'Escolha: ', 0
    msg_cf db 'Carry Flag (CF): ', 0
    msg_zf db 'Zero Flag (ZF): ', 0
    msg_sf db 'Sign Flag (SF): ', 0
    msg_of db 'Overflow Flag (OF): ', 0
    msg_pf db 'Parity Flag (PF): ', 0
    msg_df db 'Direction Flag (DF): ', 0
    msg_ativado db 'ATIVADO (1)', 0
    msg_desativado db 'desativado (0)', 0
    msg_operacao db 'Operação executada! Observe as flags', 0
    newline db 0xa, 0

section .bss
    opcao resb 2

section .text
global CMAIN
CMAIN:
    mov ebp, esp

menu_principal:
    PRINT_STRING menu
    GET_CHAR opcao
    
    cmp byte [opcao], '1'
    je testar_cf
    cmp byte [opcao], '2'
    je testar_zf
    cmp byte [opcao], '3'
    je testar_sf
    cmp byte [opcao], '4'
    je testar_of
    cmp byte [opcao], '5'
    je testar_pf
    cmp byte [opcao], '6'
    je testar_df
    cmp byte [opcao], '7'
    je mostrar_todas
    cmp byte [opcao], '0'
    je sair
    jmp menu_principal

testar_cf:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Operação que ativa CF
    mov al, 0xFF
    add al, 1
    
    ; Mostrar CF
    PRINT_STRING msg_cf
    jc cf_ativado
    PRINT_STRING msg_desativado
    jmp cf_fim
cf_ativado:
    PRINT_STRING msg_ativado
cf_fim:
    NEWLINE
    jmp menu_principal

testar_zf:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Operação que ativa ZF
    mov al, 10
    sub al, 10
    
    PRINT_STRING msg_zf
    jz zf_ativado
    PRINT_STRING msg_desativado
    jmp zf_fim
zf_ativado:
    PRINT_STRING msg_ativado
zf_fim:
    NEWLINE
    jmp menu_principal

testar_sf:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Operação que ativa SF
    mov al, 5
    sub al, 10
    
    PRINT_STRING msg_sf
    js sf_ativado
    PRINT_STRING msg_desativado
    jmp sf_fim
sf_ativado:
    PRINT_STRING msg_ativado
sf_fim:
    NEWLINE
    jmp menu_principal

testar_of:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Operação que ativa OF
    mov al, 100
    add al, 50
    
    PRINT_STRING msg_of
    jo of_ativado
    PRINT_STRING msg_desativado
    jmp of_fim
of_ativado:
    PRINT_STRING msg_ativado
of_fim:
    NEWLINE
    jmp menu_principal

testar_pf:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Operação que ativa PF
    mov al, 0x03
    
    PRINT_STRING msg_pf
    jp pf_ativado
    PRINT_STRING msg_desativado
    jmp pf_fim
pf_ativado:
    PRINT_STRING msg_ativado
pf_fim:
    NEWLINE
    jmp menu_principal

testar_df:
    PRINT_STRING msg_operacao
    NEWLINE
    ; Alternar DF
    STD
    PRINT_STRING msg_df
    PRINT_STRING msg_ativado
    NEWLINE
    
    CLD
    PRINT_STRING msg_df
    PRINT_STRING msg_desativado
    NEWLINE
    jmp menu_principal

mostrar_todas:
    NEWLINE
    PRINT_STRING '=== ESTADO ATUAL DAS FLAGS ==='
    NEWLINE
    
    ; Mostrar CF
    PRINT_STRING msg_cf
    jc cf_show
    PRINT_STRING msg_desativado
    jmp cf_next
cf_show:
    PRINT_STRING msg_ativado
cf_next:
    NEWLINE
    
    ; Mostrar ZF
    PRINT_STRING msg_zf
    jz zf_show
    PRINT_STRING msg_desativado
    jmp zf_next
zf_show:
    PRINT_STRING msg_ativado
zf_next:
    NEWLINE
    
    ; Mostrar SF
    PRINT_STRING msg_sf
    js sf_show
    PRINT_STRING msg_desativado
    jmp sf_next
sf_show:
    PRINT_STRING msg_ativado
sf_next:
    NEWLINE
    
    ; Mostrar OF
    PRINT_STRING msg_of
    jo of_show
    PRINT_STRING msg_desativado
    jmp of_next
of_show:
    PRINT_STRING msg_ativado
of_next:
    NEWLINE
    
    ; Mostrar PF
    PRINT_STRING msg_pf
    jp pf_show
    PRINT_STRING msg_desativado
    jmp pf_next
pf_show:
    PRINT_STRING msg_ativado
pf_next:
    NEWLINE
    
    jmp menu_principal

sair:
    xor eax, eax
    ret
```

## 📊 Questões para Relatório

Questões Teóricas
Estrutura do EFLAGS:
Quantos bits tem o registrador FLAGS? E EFLAGS?
Quais bits são utilizados no 8086/8088 original?
