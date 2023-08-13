bits 32

global start
extern exit, fopen, fprintf, fclose, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
)
segment data use32 class=data
    stringFormat db "%s", 0 
    message1 db "Datei=", 0 
    message2 db "Text=", 0
    
    file_name times 30 db 0
    text times 120 db 0
    write_mode db "w", 0 ;creates an empty file for writing
    file_descriptor dd -1 ;variable to hold the file descriptor


segment code use32 class=code
    start:
     
        ;print("Datei=")
        push dword message1
        call [printf]
        add esp, 4*1 
        
        ;scanf(stringFormat, file_name)
        push dword file_name
        push dword stringFormat
        call [scanf]
        add esp, 4*2
        
        ;print("Text=")
        push dword message2
        call [printf]
        add esp, 4*1
        
        ;scanf(stringFormat, text)
        push dword text
        push dword stringFormat
        call [scanf]
        add esp, 4*2
        
        ;eax = fopen(file_name, write_mode)
        push dword write_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        ;check if file was successfully created
        cmp eax, 0
        je end
        
        ;write text to file
        ;fprintf(file_descriptor, text)
        push dword text
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*2
        
        ;fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4*1
        
        end:

        push    dword 0
        call    [exit]