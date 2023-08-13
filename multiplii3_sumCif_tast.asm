bits 32
global start

extern exit, fopen, fclose, printf, scanf, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll 
import scanf msvcrt.dll 

segment data use32 class=data
    ; ptr fisier
    file_name db "output.txt", 0
    access_mode db "w", 0
    file_descriptor dd -1
    
    ; ptr citit nr
    n dd 0
    message db "n=", 0
    formatpr db "%d ", 0
    format db "%d", 0
    formaterr db "Keine Zahlen", 0


segment code use32 class=code
    start:
        ; deschide fisier
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2 
        
        
        mov [file_descriptor], eax
        cmp eax, 0
        je final
       
        mov edi, 0
       
        citire_nr:
            ; afis 'n='
            push dword message 
            call [printf] ; call function printf for printing
            add esp, 4*1
            
            ; citire n
            push dword n
            push dword format
            call [scanf]
            add esp, 4 * 2
            
            ; verif daca s-a citit 0
            mov eax, 0
            mov eax, [n]
            cmp eax, 0
            je final
            
            ; sum cifre
            mov edx, 0      ; rest
            mov ebx, 0      ; suma
            mov ecx, 10  
            sum_cifre:
                div ecx             ;eax = eax / ecx = n / 10
                add ebx, edx        ;123 / 10   edx = 3
                mov edx, 0
                cmp eax, 0
                jg sum_cifre
            
            ; vreif divizibil cu 3
            mov eax, [n]
            mov ecx, 3
            div ecx
            cmp edx, 0
            jne citire_nr
            
            ; verif suma cif >= 15
            cmp ebx, 15
            jl citire_nr
            
            ; afis in fisier
            push dword [n]
            push dword formatpr
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*3
            
            inc edi
            
            jmp citire_nr 
        
        final:
            cmp edi, 0
            jne final1
            
            push dword formaterr
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*2
    
        
        
        final1:
            ; inchide fisier
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        push    dword 0
        call    [exit]
