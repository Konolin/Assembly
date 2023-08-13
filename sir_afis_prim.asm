bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, is_prim, printf        ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import printf msvcrt.dll
extern is_prim
       
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;Lesen Sie von der Konsole eine Liste von Zahlen zur Basis 10.
    ;Schreiben Sie nur die Primzahlen auf die Konsole.
    
    aux db 0
    liste times 10 db 0
    
    msgL db "L= ", 0
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
    
        push dword msgL
        call [printf]
        add esp, 4
    
        mov esi, 0
       
        
        read_while:

        push dword aux
        push dword format
        call [scanf]
        add esp, 4
        
        push dword [aux]
        mov edx, 0
        mov ebx, 2
        
        while1:
        mov eax, [esp+4]  ;zahl in eax, eax=4
        cmp ebx, eax
        je adev

        cmp eax, 1
        je final
        
        cmp eax, 0
        je final
    
       ; push eax    ;zahl auf Stack
        div ebx     ; 4/2= 2 edx->r=0
        cmp edx, 0   ; equal
        je final
    
        ;push eax  
        mov edx, 0
        inc ebx       
        jmp while1
        
        adev:
        mov eax, dword [esp+4]
        mov [prim], eax
        push dword [prim]
        push dword format 
        call [printf]   ;fur 4 schreibt nichts
        add esp, 8
        push dword msg
        call [printf]
        add esp, 4
        
       
        final:
       
        ;pop ebx  ; bx -> 1 0 1
        ;cmp ebx, 1
        ;jne jos
        
        ;pop dword [aux]
        ;mov [aux], eax
        ;push dword [aux]
        ;push dword format 
        ;call [printf]   ;-> 2 7  
        ;add esp, 8
       
        ;jos:

        mov al, 0
        cmp [aux],al
        je end_read
        
        jmp read_while
        end_read:
        
      

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
