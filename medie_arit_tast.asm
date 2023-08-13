bits 32 
global start        

extern exit, printf, scanf               
import exit msvcrt.dll    
import printf msvcrt.dll
import scanf msvcrt.dll


segment data use32 class=data
    
    A dd 0
    B dd 0
    messageA db "a=", 0
    messageB db "b=", 0
    formatAB db "%d", 0
    formatRez db "%x", 0
    doi dw 2
    
segment code use32 class=code
    start:
        
        push dword messageA ;auf dem stack "a=" tun
        call [printf]       ;durch die Funktion printf "a=" in der Console schreiben  
        add esp, 4*1        ;stack waschen
        
        push dword A        ;auf dem stack die Variabile A initializieren
        push dword formatAB ;Variabilen A und B werden ins Dezimal-format deklariert
        call [scanf]        ;durch die Funktion scanf A von die Console lesen  
        add esp, 4*2        ;stack waschen
        
        
        ;das Selbe fuer B tun
        push dword messageB
        call [printf]
        add esp, 4*1
        
        push dword B
        push dword formatAB
        call [scanf]
        add esp, 4*2            
        
        mov eax, [A] ;eax=A
        mov ebx, [B] ;ebx=B
        add eax, ebx ;eax+=ebx
        mov edx, 0   ;rest=0
        mov cx, [doi]
        div cx       ;eax/=2
        
        ;eax=arthmetisches Mittle in decimal
       
        push dword eax ;arthmetisches Mittle
        push formatRez ;"%x" -> Basis 16        
        call [printf]  ;durch die Funktion printf dem arthmetisches Mittle von A und B in Basis 16 in der Console schreiben
        add esp, 4*2   ;Stack waschen
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
