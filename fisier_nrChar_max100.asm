bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "ana.txt", 0 ; filename to be read
    access_mode db "r", 0 ; file access mode: r - opens a file for reading. The file must exist.
    file_descriptor dd -1 ; variable to hold the file descriptor
    len equ 100 ; maximum number of characters to read
    text times (len+1) db 0 ; string to hold the text which is read from file
    format db "We've read %d chars from file. The text is: %s", 0


; our code starts here
segment code use32 class=code
    start:
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2 ; clean-up the stack
        
        
        mov [file_descriptor], eax ; store the file descriptor returned by fopen
        ; check if fopen() has successfully created the file (EAX != 0)
        cmp eax, 0
        je final
        
        
        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the number of chars we've read
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        
        
        ; display the number of chars we've read and the text
        ; printf(format, eax, text)
        push dword text
        push dword EAX
        push dword format
        call [printf]
        add esp, 4*3
        
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        
        final:

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
