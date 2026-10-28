extern printf
extern scanf
section .data
fmtInt: db "%d",0xA,0x0
msg: db "Digite o valor",0xA,0x0
msgSaida: db "Resultado",0xA,0x0
section .bss
a resd 1
b resd 1
r resd 1
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;printf(msg)
    push msg
    call printf
    add esp,4
    
    ;scanf("%d",&a)
    push a
    push fmtInt
    call scanf
    add esp,8   
    
    push dword[a]
    push fmtInt
    call printf
    add esp,8 
    
    push msg
    call printf
    add esp,4
    
    ;scanf("%d",&b)
    push b
    push fmtInt
    call scanf
    add esp,8      
    
    push dword[b]
    push fmtInt
    call printf
    add esp,8
    
    call soma
    
    push msgSaida
    call printf
    add esp,4
    
    push dword[r]
    push fmtInt
    call printf
    add esp,8
    
    mov dword[r],0      
    
    mov ebp,esp
    push ebp
    
    push dword[a]
    push dword[b]
    call somaref
        
    xor eax, eax
    ret
    
soma: 
      mov eax,dword[a]
      mov ebx,dword[b]
      add eax,ebx
      mov dword[r],eax
      ret

somaref:     
       pop eax
       pop eax
       pop ebx
       add eax,ebx       
       mov dword[r],eax            
       ret
      
      
 ; push 
 ; mov 