bits 32

global start  
extern exit, fopen, fprintf, scanf, fclose, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll    
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    file_name db "abc.txt", 0   ; filename to be created
    access_mode db "w", 0       ; file access mode:; w - creates an empty filefor writing
    file_descriptor dd -1       ; variable to hold the file
    descriptortext db "Ana are mere.", 0  ; text to be write to file
    n dd 0       ; in this variable we'll store thevalueread from the keyboard; char strings are of type byte
    message db "n=", 0  ; char strings for C functionsmustterminate with 0(value, not char)
    format db "%d, ", 0  ; %d <=> a decimal number (base10)
    sapte dw 7

segment code use32 class=code
    start:
        push dword access_mode
        push dword file_name
        call [fopen]
        ;file oeffnen
        add esp, 4*2 ;Stack waschen
        
        mov [file_descriptor], eax ; store the filedescriptor returned by fopen
        cmp eax, 0
        je final                   ;wenn dem file nicht korrekt gebildet oder geoeffnet war -> final
        
        push dword message ; ! on the stack is placed the address of the string, not its value
        call [printf]      ; call function printffor printing
        add esp, 4*1       ; free parameters on thestack; 4 =size of dword; 1 = number of parameters
        
        push dword n      ; ! addressa of n, notvalue
        push dword format
        call [scanf]      ; call function scanf forreading
        add esp, 4 * 2    ;stack waschen
        mov ebx,[n]       ;eine mare copie von n in ebx speichern
        mov eax, [n]      ;in eax wird n gespeichert
        cmp eax,0         ;while n!=0
        je EndWhile
        wwhile:
            mov cl, [sapte]
            div cl
            ;eax durch 7 teilen
            cmp ah,0
            je SiebenTeilbar
            ;wenn es durch 7 teilbar ist -> SiebenTeilbar
            jmp endiif 
            ;wenn es NICHT durch 7 teilbar ist -> eine neue Zahl n lesen
            SiebenTeilbar:
                push dword ebx ;die Kopie (ungeteilte n) im Stack speichern
                push dword format; ihrem Format im Stack speichern
                push dword [file_descriptor];die File Adressen im Stack speichern
                call [fprintf];die durch 7 divbare Zahl im File speichern
                add esp, 4*2;Stack waschen
                jmp endiif;JUST IN CASE
            endiif:
            
            push dword message; ! on the stack is placedtheaddress of the string, not its value
            call [printf]; call function printffor printing
            add esp, 4*1; free parameters on thestack; 4 =size of dword; 1 = number of parameters
            
            push dword n; ! addressa of n, notvalue
            push dword format
            call [scanf]; call function scanf forreading
            add esp, 4 * 2;stack waschen
            
            ;eine neue Zahl n lesen
            
            mov ebx, [n] ;eine mare copie von n in ebx speichern
            mov eax, [n] ;in eax wird n gespeichert
            cmp eax,0
            jne wwhile ;while n!=0
            
        EndWhile:
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        final:
        
        push    dword 0
        call    [exit]
        