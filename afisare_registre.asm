bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; string of bytes
    format db "%d", 0 ; %d <=> decimal number


; our code starts here
segment code use32 class=code
    start:
        ; will calculate 20 + 123 + 7 in EAX
        mov eax, 20
        add eax, 123
        add eax, 7
        ; save the value of the registers, printf will modify their values
        ; use PUSHAD: saves on stack the values of: EAX, ECX, EDX and EBX
        PUSHAD
        
        ; will call printf(format, eax) => will print value from eax
        ; place parameters on stack from right to left
        push dword eax
        push dword format   ; address of string on stack, not value
        call [printf]       ; call function for printing
        add esp, 4*2        ; free parameters on the stack; 4 = size of dword; 2 = number of parameters
        
        
        ; restore value of registers saved on stack using POPAD
        ; takes values from the stack and restores them in: EAX, ECX, EDX and EBX
        ; it is important that before calling POPAD we make sure there are enough values on stack (for example make sure that PUSHAD was called before)
        POPAD

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
