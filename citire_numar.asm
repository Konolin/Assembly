bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf 
import exit msvcrt.dll
import printf msvcrt.dll 
import scanf msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0              ; in this variable we'll store the value read from the keyboard
                        ; char strings are of type byte
    message db "n=", 0  ; char strings for C functions must terminate with 0(value, not char)
    format db "%d", 0   ; %d <=> a decimal number (base 10)

; our code starts here
segment code use32 class=code
    start:
        ; will call printf(message) => will print "n="
        ; place parameters on stack
        push dword message 
        call [printf] ; call function printf for printing
        add esp, 4*1 ; free parameters on the stack; 4 = size of dword; 1 = number of parameters
        
        
        ; will call scanf(format, n) => will read a number in variable n
        ; place parameters on stack from right to left
        push dword n ; ! addressa of n, not value
        push dword format
        call [scanf] ; call function scanf for reading
        add esp, 4 * 2 ; free parameters on the stack
        ; 4 = size of a dword; 2 = no of perameters

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
