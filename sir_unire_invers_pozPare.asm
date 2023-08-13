bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s1 db '+', '2', '2', 'b', '8', '6', 'X', '8'
    l1 equ $-s1
    
    s2 db 'a', '4', '5'
    l2 equ $-s2
    
    d times l2+(l1/2) db 0
    
segment code use32 class=code
    start:
        ; S2 in ordine inversa si S1 doar elem de pe poz pare
        ; S1:'+', '2', '2', 'b', '8', '6', 'X', '8'
        ; S2:'a', '4', '5'
        ; D:'5', '4', 'a', '2','b', '6', '8'
        
        
        mov ecx, l2     ;wir setzen die Länge l2 in ECX, um die Schleife zu machen
        mov esi, l2-1   ;wir setzen die Länge l2-1 in ESI, um die Folge von rechts nach links durchzulaufen 
        mov edi, 0
        jecxz Mijloc
        Repeta1:
            mov al, [s2+esi]    ;wir nehmen das Element von der esi Position
            mov [d+edi], al     ;wir fügen das Element in der neuen Folge
            inc edi
            dec esi 
        loop Repeta1 
        
        Mijloc:
            mov ecx, l1/2   ;wir setzen die Länge l1/2 in ECX, um die Schleife zu machen
            mov esi, 1      ;wir setzen 1 in ESI, um wir mit dem ersten Element auf einer geraden Position zu beginnen
            
        jecxz Sfarsit
        Repeta2:
            mov al, [s1+esi]    ;wir nehmen das Element von der esi Position
            mov [d+edi], al     ;wir fügen das Element in der neuen Folge
            inc esi             ;wir erhöhen ESI zweimal, um die Zahlen an ungeraden Positionen zu überspringen
            inc esi
            inc edi
        loop Repeta2
        
        Sfarsit:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
