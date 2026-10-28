extern printf
extern scanf

section .data
msgMenor: db "menor",0xa,0x0
msgMaior: db "maior",0xa,0x0
nome: db "carlos",0xa,0x0

section .bss
s resd 1
i resd 1
global main
section .text
main:
    mov ebp, esp; for correct debugging

    mov dword[i],0
    while: cmp dword[i],3
    je fim
    push nome
    call printf
    add esp,4      
    inc dword[i]
    jmp while
                     
    fim:
 xor eax,eax


; dois

extern printf
extern scanf

section .data
msgMenor: db "menor",0xa,0x0
msgMaior: db "maior",0xa,0x0
section .bss
s resd 1
i resd 1
global main
section .text
main:
    mov ebp, esp; for correct debugging

    mov dword[s],0
    mov dword[i],0
    repita:  cmp dword[i],10
    jl bloco_menor    
    jmp fim
    bloco_menor:
    mov eax,dword[s]
    add eax,2
    mov dword[s],eax
    inc dword[i]
    jmp repita       
    fim:
 xor eax,eax


; tres
extern printf
extern scanf

section .data
msgMenor: db "menor",0xa,0x0
msgMaior: db "maior",0xa,0x0
nome: db "carlos",0xa,0x0
section .bss
s resd 1
i resd 1
global main
section .text
main:
    mov ebp, esp; for correct debugging

    mov ecx,3
    .for: 
    push ecx
    
    push nome
    call printf
    add esp,4
    
    pop ecx
    loop .for   
    
    fim:
 xor eax,eax


