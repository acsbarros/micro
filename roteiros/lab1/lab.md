Roteiro da Primeira Prática - Movimentação de Dados e Registradores
Laboratório 1: Manipulação de Registradores 8086/8088
Disciplina: Microprocessadores 8086/8088
Professor: Carlos Barros - UNILAB
Duração: 2 horas

🎯 Objetivos da Prática
Ao final desta prática, o aluno será capaz de:

Compreender a hierarquia e tamanho dos registradores EAX, AX, AH, AL, EBX, BX, BH, BL

Realizar movimentação de dados entre registradores e memória

Identificar problemas de tamanho (truncamento) na movimentação de dados

Entender o conceito de números com e sem sinal

Identificar e explicar situações de overflow

📚 Fundamentos Teóricos
1. Registradores do 8086/8088
Os registradores do 8086/8088 são de 16 bits, mas os processadores modernos (modo protegido) permitem acesso a versões estendidas de 32 bits (EAX, EBX, etc.).

text
EAX (32 bits) - Extended AX
├── AX (16 bits) - Acumulador
│   ├── AH (8 bits) - High byte
│   └── AL (8 bits) - Low byte

EBX (32 bits) - Extended BX
├── BX (16 bits) - Base
│   ├── BH (8 bits) - High byte
│   └── BL (8 bits) - Low byte

2. Capacidade de armazenamento
Registrador	Tamanho	Faixa sem sinal	Faixa com sinal
AL, BL, AH, BH	8 bits	0 a 255	-128 a +127
AX, BX	16 bits	0 a 65535	-32768 a +32767
EAX, EBX	32 bits	0 a 4.294.967.295	-2.147.483.648 a +2.147.483.647


3. Flags importantes
Flag	Nome	Significado
CF (Carry Flag)	Flag de transporte	Indica carry/borrow em operações sem sinal
OF (Overflow Flag)	Flag de overflow	Indica overflow em operações com sinal
ZF (Zero Flag)	Flag de zero	Indica resultado igual a zero
SF (Sign Flag)	Flag de sinal	Indica resultado negativo (bit mais significativo = 1)

🛠️ Materiais Necessários
Computador com Linux (ou VM)

NASM instalado

SASM instalado (opcional para debug)

Acesso ao terminal

📝 Exercícios Práticos
Exercício 1: Conhecendo os Registradores
Objetivo: Visualizar como os registradores EAX, AX, AH e AL compartilham o mesmo espaço.

Código: registradores.asm

section .data
    msg1 db 'EAX = ', 0
    msg2 db 'AX = ', 0
    msg3 db 'AH = ', 0
    msg4 db 'AL = ', 0
    newline db 0xa
    espaco db ' ', 0

section .bss
    buffer resb 16

section .text
    global _start

_start:
    ; Carregando valores para demonstrar compartilhamento
    mov eax, 0x12345678    ; EAX recebe valor de 32 bits
    
    ; Agora vamos mostrar os valores:
    ; AX = 0x5678 (parte baixa)
    ; AH = 0x56 (byte alto de AX)
    ; AL = 0x78 (byte baixo de AX)
    
    ; Para visualizar, usaremos chamadas de sistema
    ; Como é complexo converter hex para string,
    ; vamos usar o debugger (SASM) para ver os valores
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

Tarefa 1: Carregue este código no SASM e use o debugger (F7) para observar:

Coloque um breakpoint após o mov eax, 0x12345678

Observe o valor de EAX, AX, AH e AL

Anote os valores em uma tabela

Tabela de observação:

Registrador	Valor esperado	Valor observado
EAX (32 bits)	0x12345678	
AX (16 bits)	0x5678	
AH (8 bits)	0x56	
AL (8 bits)	0x78

Exercício 2: Movimentação e Truncamento
Objetivo: Entender o truncamento ao mover valores de maior para menor tamanho.

Código: truncamento.asm

section .data
    msg_origem db 'Valor original em EAX: 0x1234ABCD', 0xa
    len_orig equ $ - msg_origem
    msg_ax db 'Valor em AX: 0x', 0
    msg_ah db 'Valor em AH: 0x', 0
    msg_al db 'Valor em AL: 0x', 0
    newline db 0xa

section .bss
    hex_buffer resb 9

section .text
    global _start

_start:
    ; Carrega valor de 32 bits
    mov eax, 0x1234ABCD
    
    ; Movimentações com truncamento
    mov bx, ax        ; BX recebe AX (16 bits baixos)
    mov cx, bx        ; CX recebe BX
    mov dl, cl        ; DL recebe CL (byte baixo de CX)
    
    ; O que aconteceu?
    ; EAX = 0x1234ABCD
    ; AX  = 0xABCD
    ; BX  = 0xABCD
    ; CX  = 0xABCD
    ; CL  = 0xCD
    ; DL  = 0xCD
    
    ; Observação importante: 
    ; Movendo EAX para AL, perdemos os bits altos!
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

    Questões para responder (no relatório):

Qual o valor final em DL? Por quê?

O que aconteceria se fizéssemos mov al, 0x123? Explique.

Por que não podemos fazer mov ax, eax diretamente?

Experimento extra: Altere o código para testar:

mov eax, 0xFFFFFFFF
mov al, 0x00
; Qual o valor de EAX agora? Por quê?

Exercício 3: Números com e sem Sinal
Objetivo: Diferenciar representação com sinal (complemento de 2) e sem sinal.

Código: sinal.asm

section .data
    msg_unsigned db 'Interpretação sem sinal:', 0xa
    len_uns equ $ - msg_unsigned
    msg_signed db 'Interpretação com sinal:', 0xa
    len_sig equ $ - msg_signed
    newline db 0xa

section .text
    global _start

_start:
    ; Exemplo 1: Valor 0xFF em AL (8 bits)
    mov al, 0xFF
    
    ; Sem sinal: 255
    ; Com sinal: -1 (pois 0xFF em complemento de 2 = -1)
    
    ; Exemplo 2: Valor 0x80 em AL
    mov al, 0x80
    
    ; Sem sinal: 128
    ; Com sinal: -128
    
    ; Exemplo 3: Valor 0x7F em AL
    mov al, 0x7F
    
    ; Sem sinal: 127
    ; Com sinal: 127
    
    ; Exemplo 4: Demonstração com 16 bits
    mov ax, 0xFFFF
    
    ; Sem sinal: 65535
    ; Com sinal: -1
    
    ; Exemplo 5: Demonstração com 32 bits
    mov eax, 0xFFFFFFFF
    
    ; Sem sinal: 4294967295
    ; Com sinal: -1
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

    Questões para responder:

Por que 0xFF é interpretado como -1 quando consideramos sinal?

Qual a faixa de valores para um número com sinal de 8 bits?

Como representar o número -5 em complemento de 2 no registrador AL?

Tabela de conversão (preencher):

Binário	Hex	Sem sinal	Com sinal
00000001	0x01	1	1
11111111	0xFF		
10000000	0x80		
01111111	0x7F		
11111110	0xFE

Exercício 4: Overflow - Quando a conta não cabe
Objetivo: Identificar situações de overflow em operações com e sem sinal.

Código: overflow.asm

section .data
    msg_overflow db 'Overflow detectado!', 0xa
    len_ovf equ $ - msg_overflow
    msg_normal db 'Operação normal', 0xa
    len_nor equ $ - msg_normal

section .text
    global _start

_start:
    ; ==========================================
    ; CASO 1: Overflow sem sinal (Carry Flag)
    ; ==========================================
    ; AL tem 8 bits, máximo sem sinal = 255
    mov al, 200
    add al, 100    ; 200 + 100 = 300 (>255)
    
    ; Resultado em AL = 44 (300 - 256 = 44)
    ; Carry Flag (CF) será ativado
    
    ; ==========================================
    ; CASO 2: Overflow com sinal (Overflow Flag)
    ; ==========================================
    ; AL com sinal: máximo = 127
    mov al, 100
    add al, 50     ; 100 + 50 = 150 (>127)
    
    ; Resultado em AL = -106 (150 - 256 = -106)
    ; Overflow Flag (OF) será ativado
    
    ; ==========================================
    ; CASO 3: Overflow com 16 bits
    ; ==========================================
    ; AX com sinal: máximo = 32767
    mov ax, 30000
    add ax, 5000   ; 30000 + 5000 = 35000 (>32767)
    
    ; ==========================================
    ; CASO 4: Subtração com borrow
    ; ==========================================
    mov al, 10
    sub al, 20     ; 10 - 20 = -10
    ; Carry Flag (CF) ativado (borrow)
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

    Questões para responder:

Explique a diferença entre Carry Flag (CF) e Overflow Flag (OF).

No CASO 1, qual o valor final em AL e por que CF foi ativado?

No CASO 2, por que OF foi ativado mas CF não?

Qual a utilidade prática de cada flag?

Exercício 5: Prática com SASM - Observando Flags
Objetivo: Usar o debugger do SASM para visualizar flags em tempo real.

Código: flags_sasm.asm (para usar no SASM)

%include "io.inc"

section .data
    msg1 db 'Teste de Flags - 8086/8088', 0
    msg2 db 'Pressione F7 para debug e observe as flags', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    PRINT_STRING msg1
    NEWLINE
    PRINT_STRING msg2
    NEWLINE
    
    ; Ponto de parada 1 - Coloque breakpoint aqui
    mov al, 0xFF
    add al, 1        ; Deve ativar CF (carry)
    
    ; Ponto de parada 2
    mov al, 0x7F
    add al, 1        ; Deve ativar OF (overflow com sinal)
    
    ; Ponto de parada 3
    mov al, 0x80
    add al, 0x80     ; 128 + 128 = 256, ativa CF
    
    ; Ponto de parada 4
    mov al, 0x40
    add al, 0x40     ; 64 + 64 = 128, ativa OF (pois 128 é negativo em sinal)
    
    xor eax, eax
    ret

    Procedimento no SASM:

Copie o código acima no SASM

Clique em Debug (F7)

Adicione breakpoints clicando nas linhas marcadas

Execute passo a passo com F8

Observe o painel de Registers e Flags após cada operação

Tabela para preencher durante o debug:

Operação	Valor em AL (hex)	Valor em AL (decimal)	CF	OF	ZF	SF	O que aconteceu?
0xFF + 1							
0x7F + 1							
0x80 + 0x80							
0x40 + 0x40	


📊 Questões Conceituais
Responda no relatório:

Tamanho e Capacidade:

Quantos bits tem o registrador AX? E AH?

Qual o maior número sem sinal que cabe em BL?

Qual o menor número com sinal que cabe em AL?

Movimentação:

O que acontece ao executar mov ax, 0xFFAA e depois mov al, 0x55?

É possível mover o conteúdo de EAX para AL diretamente? Justifique.

Sinal e Overflow:

Explique com suas palavras o conceito de complemento de 2.

Dê um exemplo onde ocorre overflow mas não carry.

Dê um exemplo onde ocorre carry mas não overflow.

Análise de código:


mov eax, 0xFFFFFFFF
add eax, 1

🧪 Desafios Extras (para alunos avançados)
Desafio 1: Detector de Overflow
Escreva um programa que recebe dois números (em AL e BL), soma e indica se houve overflow com sinal.

Desafio 2: Conversor de sinal
Escreva um programa que converte um número com sinal para sua representação em complemento de 2.

Desafio 3: Máquina de estados das flags
Crie uma tabela verdade mostrando o estado das flags (CF, OF, ZF, SF) para todas as combinações de soma de dois números de 4 bits.

📝 Formato do Relatório

# Relatório da Primeira Prática - Registradores e Flags

**Aluno:** [Nome completo]
**Matrícula:** [Número]
**Data:** [Data da prática]

## 1. Objetivos
[Descrever os objetivos da prática com suas palavras]

## 2. Desenvolvimento

### 2.1 Exercício 1 - Conhecendo Registradores
[Colar tabela preenchida e observações]

### 2.2 Exercício 2 - Truncamento
[Responder questões]
[Código modificado, se houver]

### 2.3 Exercício 3 - Números com e sem Sinal
[Responder questões]
[Tabela preenchida]

### 2.4 Exercício 4 - Overflow
[Responder questões]
[Explicação dos casos]

### 2.5 Exercício 5 - Flags no SASM
[Colar tabela preenchida]
[Screenshots do debug, se possível]

## 3. Questões Conceituais
[Respostas completas]

## 4. Desafios (opcional)
[Códigos e explicações]

## 5. Dificuldades Encontradas
[Descrever problemas e soluções]

## 6. Conclusão
[O que aprendeu, importância dos conceitos]

## 7. Códigos Fonte
[Colar todos os códigos desenvolvidos]

✅ Checklist de Verificação
Antes de finalizar, verifique se você:

Compilou e executou todos os códigos

Preencheu todas as tabelas de observação

Respondeu todas as questões teóricas

Utilizou o debugger do SASM para visualizar flags

Entende a diferença entre CF e OF

Sabe identificar quando ocorre truncamento

Consegue explicar complemento de 2

Preparou o relatório completo

📚 Referências para Estudo
x86 Flags - Guia completo

Complemento de 2 - Explicação visual

NASM Tutorial com exemplos

🎯 Rubrica de Avaliação
Critério	Peso	Pontuação
Execução correta dos códigos	20%	/20
Preenchimento das tabelas	15%	/15
Questões conceituais	30%	/30
Relatório completo e organizado	20%	/20
Participação e discussão	15%	/15
TOTAL	100%	/100

Boa prática!
Prof. Carlos Barros - UNILAB

Este roteiro cobre todos os pontos solicitados:
✅ Movimentação em registradores (EAX, AX, AH, AL, EBX, BX, BH, BL)
✅ Questões de tamanho e truncamento
✅ Número de bits
✅ Questão de sinal (complemento de 2)
✅ Questão de overflow (CF vs OF)
✅ Exercícios práticos com NASM e SASM
✅ Tabelas para preenchimento
✅ Questões teóricas
✅ Desafios extras
✅ Template de relatório completo