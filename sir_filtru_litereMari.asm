bits 32

global start        
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 'a', 'A', 'b', 'B', '2', '%', 'M' 
    l equ $-s 
    d times 1 db 0 

segment code use32 class=code
    start:
    
     mov ecx, l 
     mov esi, 0 
     mov edi, 0 
     
     jecxz Ende
     Wiederhole:
        mov al, [s+esi]
        
        ; verif daca litera e in intervalul ['A', 'Z']
        cmp al, 'A'
        jb endif
        cmp al, 'Z'
        ja endif
        
        mov [d+edi], al
        inc edi

        endif:
        inc esi 
     
        loop Wiederhole
        
     Ende:
     
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
