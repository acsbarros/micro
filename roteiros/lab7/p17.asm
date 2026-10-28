extern scanf
extern printf
%include "io.inc"
section .data
intFormat: db "%d",0xd
a: dq 1.0
b: dq -3.0
c: dq 2.0
minus4: dq -4.0
temp: dq 0.0
format: db "%f", 10, 0
no_roots_msg: db "No real roots",10,0
section .bss
x resd 1
section .text
global main
main:
mov ebp, esp; for correct debugging
;write your code here
finit
fld qword[b]; move para st0(-4)
fld qword[b]; move para st1(-4)
fmulp st1 ;multiplicar ST(0) por ST(1) e armazenar o resultado em ST(1)
fld qword[c] ; move para st0(2)
fld qword[a] ; move para st1(1)
fld qword[minus4];move para st3(-4)
fmulp st1 ; -4*a
fmulp st1 ; -4*a*c
faddp st1 ; -4*a*c +b*b
fldz ; st0(0)
fcomip ST1 ; comparação de ponto flutuante entre dois valores. S0 e S1
; após fcomip st0 (valor anterior) é removido da pilha quem estava em st1 vai para st0
ja no_roots ; caso st1 seja menor que zero
fsqrt ;
fld st0
fld qword [b]
faddp st1
fchs ; troca o sinal do número de ponto flutuante de st0
fld qword [a]
fld1
fld1
faddp
fmulp
fdivp ST1
; print st0
fst qword [temp] ; armazena o valor do topo da pilha em temp (64bits)
push dword [temp+4]
push dword [temp]
push format
call printf
add esp, 12
fcomp
fld qword [b] ; move para st0(-4)
fchs ; ; troca o sinal do número de ponto flutuante de st0
faddp
fld qword [a]
fld1
fld1
faddp
fmulp
fdivp ST1 ; ST1 /= ST0 ; ST(1) := ST(1) / ST(0) (divisão)
; print st0
fst qword [temp]
push dword [temp+4]
push dword [temp]
push format
call printf
add esp, 12
jmp endl
no_roots:
mov eax, no_roots_msg
call printf
endl:
xor eax, eax
ret
