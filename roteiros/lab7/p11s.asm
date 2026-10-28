;utilização de rotinas externas (c++)
extern printf
extern scanf
;criar a seção dos dados inicializados
section .data
msg: db "Digite o valor",0xa,0x0
fmtInt: db "%d",0xa,0x0

;criar a seção dos dados não inicializados
section .bss 
x resd 1
y resd 1
soma resd 1
idade resb 1
notas resd 10 ; float notas[10]
;criar a seção do codigo
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    ;printf(msg)
    push msg
    call printf
    add esp,4
    
    ;scanf("%d",&x)
    push x
    push fmtInt
    call scanf
    add esp,8
    
    ;scanf("%d",&y)
    push y
    push fmtInt
    call scanf
    add esp,8
    
    mov eax,dword[x]
    add eax,dword[y]
    mov dword[soma],eax
    
    ;print("%d",soma)
    push dword[soma]
    push fmtInt
    call printf
    add esp,8
    
    
         
        
    xor eax,eax ; 





