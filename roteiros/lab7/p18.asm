extern printf
section .data
fmtF: db "%.2f",0x0
m1 dq 1.0
m2 dq 2.0
m3 dq 0.0 
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    
    finit 
    
fld QWORD[m1]
fld st0
fmulp st1,st0
fld QWORD[m2]
fld st0
fmulp st1,st0
faddp st1,st0
fsqrt
fst QWORD[m3]

push dword[m3+4]
push dword[m3]
push fmtF
call printf
add esp, 12


    
    xor eax, eax
    
    
    ret