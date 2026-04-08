# Microprocessadores 8086/8088 - Laboratório

**Prof. Carlos Barros**  
**UNILAB - Universidade da Integração Internacional da Lusofonia Afro-Brasileira**

Bem-vindo ao repositório da disciplina! Aqui você encontrará materiais, códigos-exemplo e roteiros para os laboratórios de programação em assembly para os microprocessadores 8086/8088.

## 📁 Estrutura do Repositório
```text
.
├── exemplos/ # Códigos exemplo vistos em aula
│ ├── hello.asm
│ ├── soma.asm
│ └── condicional.asm
├── exercicios/ # Listas de exercícios práticos
│ ├── lista1.md
│ └── lista2.md
├── ferramentas/ # Guias de instalação e uso
│ ├── instalacao_nasm.md
│ └── sasm_guide.md
├── roteiros/ # Roteiros de laboratório passo-a-passo
│ ├── lab1_nasm.md
│ └── lab2_sasm.md
└── README.md # Este arquivo
```

## 🛠️ Ferramentas Utilizadas

| Ferramenta | Função | Ambiente |
|------------|--------|----------|
| **NASM** (Netwide Assembler) | Montagem de código assembly para gerar executáveis | Terminal/Linha de comando |
| **SASM** (SimpleASM) | IDE gráfica com depurador integrado | Interface gráfica (Windows/Linux) |

## 🔧 Configuração do Ambiente

### Linux (recomendado para NASM)
```bash
# Instalar NASM e linker ld (já incluso no binutils)
sudo apt update
sudo apt install nasm build-essential

# Instalar SASM (via PPA)
sudo add-apt-repository ppa:dhor/myway
sudo apt update
sudo apt install sasm

```

Windows
NASM: Baixe do site oficial (https://www.nasm.us/pub/nasm/releasebuilds/) e adicione ao PATH

SASM: Baixe o instalador do site oficial (https://dman95.github.io/SASM/english.html)

#### 🚀 Trabalhando com NASM (Terminal)

Fluxo básico de compilação e execução (Linux)

##### 1. Crie um arquivo .asm (exemplo.asm):

```assembly
section .data
    msg db 'Olá, UNILAB!', 0xa
    len equ $ - msg

section .text
    global _start

_start:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80
```

##### 2. Montar com NASM:

```bash
nasm -f elf32 exemplo.asm -o exemplo.o
```

##### 3. Linkar (gerar executável):

```bash
ld -m elf_i386 exemplo.o -o exemplo
```

##### 4. Executar:

```bash
./exemplo
```

##### Comandos úteis do NASM

```bash
nasm -f elf32 arquivo.asm -o arquivo.o	Gera objeto 32 bits
nasm -f bin arquivo.asm -o arquivo.com	Gera .COM (DOS)
ld -m elf_i386 arquivo.o -o programa	Linkagem para Linux 32 bits
objdump -d programa	Desmonta o executável
```

#### 🖥️ Trabalhando com SASM (IDE Gráfica)

Interface do SASM
Área de edição - escreva seu código assembly

Botões principais:

Build (F5) - compila o código

Run (F6) - executa

Debug (F7) - abre o depurador

Exemplo para SASM (formato compatível)

```assembly
%include "io.inc"   ; macros para entrada/saída no SASM

section .data
    msg db 'Valor: ', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    ; seu código aqui
    PRINT_STRING msg
    mov eax, 42
    PRINT_DEC 4, eax
    NEWLINE
    xor eax, eax
    ret
```

Depurando no SASM
F7 inicia o debug

F8 executa passo a passo (step over)

F9 entra em sub-rotinas (step into)

Use Watch para monitorar registradores e variáveis

#### 📝 Roteiro Prático Rápido - Laboratório 1

Objetivo: Primeiro programa com NASM
Abra o terminal e crie uma pasta lab1

Crie o arquivo hello.asm com o código acima

Monte: nasm -f elf32 hello.asm -o hello.o

Linke: ld -m elf_i386 hello.o -o hello

Execute: ./hello

Modifique a mensagem e repita o processo

Exercício de fixação
Crie um programa que:

Declare duas variáveis (n1=10, n2=20)

Some as duas

Exiba o resultado na tela (use sys_write)

🧪 Exemplos Práticos (Cole no SASM ou use com NASM)
Exemplo 1: Loop simples
```assembly
section .data
    cont db 5

section .text
    global _start
_start:
    mov ecx, 5
loop_start:
    ; seu código aqui
    loop loop_start

    mov eax, 1
    xor ebx, ebx
    int 0x80

Exemplo 2: Acesso à memória

section .data
    valor dw 0x1234

section .text
    global _start
_start:
    mov ax, [valor]    ; copia conteúdo para AX
    add ax, 1
    mov [valor], ax    ; armazena de volta
    ; ... saída
```

### ⚠️ Erros Comuns e Soluções
relocation truncated to fit - Esqueceu de usar -m elf_i386 no ld - Use o parâmetro correto
invalid instruction - Sintaxe NASM vs MASM diferent - Revise a sintaxe (ex: mov ax, 5 e não mov ax, 5h)
segmentation fault - Acesso inválido à memória ou falta int 0x80 - Verifique os ponteiros e chamadas de sistema
SASM: no output	Esqueceu de usar PRINT_* ou ret no final - Inclua as macros e termine com ret

### 📚 Material de Apoio
NASM Documentation
SASM GitHub
Tabela de syscalls Linux x86
Referência rápida 8086

### 📅 Cronograma de Laboratórios (Sugestão)

1	Introdução, ambiente, primeiro programa	NASM
2	Movimentação de dados, endereçamentos	NASM
3	Aritmética e saltos condicionais	NASM
4	Laços e vetores	NASM
5	Pilha e sub-rotinas	SASM
6	Depuração avançada	SASM
7	Projeto final	Ambas

### 💬 Contato e Dúvidas
Professor Carlos Barros
E-mail: carlos.barros@unilab.edu.br
Atendimento: Quintas-feiras, 14h-16h (laboratório ou online)

Bom trabalho, futuros arquitetos de computadores!
"No assembly, ninguém ouve você pedir por garbage collector." 😉

```text
---
Esse README cobre:
- **Contexto acadêmico** (identificação sua e da UNILAB)
- **Duas ferramentas** (NASM no terminal e SASM gráfico)
- **Fluxos completos** (instalação, compilação, execução, debugging)
- **Exemplos práticos** prontos para copiar/colar
- **Tabela de erros comuns** (para os alunos não travarem)
- **Roteiro rápido** para o primeiro laboratório
- **Sugestão de cronograma** e links úteis

Sugiro que você personalize:
- Seu e-mail e horário de atendimento
- As listas de exercícios (crie arquivos `.md` nas pastas indicadas)
- Os exemplos conforme sua didática em sala

Crie o repositório no GitHub/GitLab da UNILAB, adicione este README e ele já estará funcional. Os alunos podem clonar e começar a praticar imediatamente.
```
