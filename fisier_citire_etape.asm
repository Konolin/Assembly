bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "input.txt", 0   ; numele fisierului care va fi deschis
    mod_acces db "r", 0             ; modul de deschidere a fisierului; r - pentru scriere. fisierul trebuie sa existe
    descriptor_fis dd -1            ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
    nr_car_citite dd 0              ; variabila in care vom salva numarul de caractere citit din fisier in etapa curenta
    len equ 100                     ; numarul maxim de elemente citite din fisier intr-o etapa
    buffer resb len                 ; sirul in care se va citi textul din fisier

; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a deschide fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        mov [descriptor_fis], eax       ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        
        
        bucla:
            ; citim o parte (100 caractere) din text folosind fread
            ; eax = fread(buffer, 1, len, descriptor_fis)
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            
            
            ; eax = numar de caractere / bytes citite
            cmp eax, 0 ; daca numarul de caractere citite este 0, am terminat de parcurs fisierul
            je cleanup
            mov [nr_car_citite], eax ; salvam numarul de caractere citie
            
            
            ; aici lucrezi pe caracterele citite
            
            
            ; reluam bucla pentru a citi alt bloc de caractere
            jmp bucla
            
            
        cleanup:
            ; apelam functia fclose pentru a inchide fisierul
            ; fclose(descriptor_fis)
            push dword [descriptor_fis]
            call [fclose]
            add esp, 4
        final:

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
