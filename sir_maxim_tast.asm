bits 32

global start
extern exit,scanf,printf
import exit msvcrt.dll  
import scanf msvcrt.dll
import printf msvcrt.dll
extern maxnum                  

global n

segment data use32 class=data
    n resd 100
    len_n equ $ - n
    last_n equ $ - 4
    format db "%d", 0
    ausgabe db "%d,", 0
        
segment code use32 class=code
    start:
        mov ecx, len_n
        mov esi, last_n
        std
        
        loop_anfang: 
            push ecx
            
            push dword esi
            push dword format
            call [scanf]
            add esp, 4*2
            
            pop ecx
            lodsd       ; doubleword in eax
            cmp eax,0   ; citeste pana la un 0
            je endelesen
            loop loop_anfang
        endelesen:
        
        
        ;jetzt wird die größte Zahl ermittelt
        
        push dword len_n
        push dword last_n
        push dword ebx  ;was maxnum zuruck gibt
        
        mov ecx, dword[ebp+ 16] ;len_n
        mov esi, dword[ebp+ 12] ;last_n
        mov edx, 0  ;größte Zahl
        
        loop3:
        lodsd
        cmp eax, edx ;vergleicht alle Zahlen mit die groste Zahl
        jng endif
        mov edx, eax
        endif:
        loop loop3        
        mov [ebp+8], edx  ;speichert die groste Zahl
        pop ebx  ;speichert größter Wert
        add esp, 4*2
        
        push dword ebx
        push dword ausgabe
        call[printf]
        add esp, 4*2
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
