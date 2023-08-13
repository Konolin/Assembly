bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "Ana has %d apples", 0 ; %d will be replaced with a
    
; our code starts here
segment code use32 class=code
    start:
        mov eax, 17
        
        ; place parameters on the stack from right to left
        push dword eax
        push dword format ;on the stack is placed the address of the string, not its value
        call [printf] ; call function printf for printing
        add esp, 4 * 2 ; free parameters on the stack; 4 = size of dword; 2 = number of parameters

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
