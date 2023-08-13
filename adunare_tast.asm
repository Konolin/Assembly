bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll    ; man sagt Assembler, dass sich die Funktion printf in msvcrt.dll befindet
import scanf msvcrt.dll     ; wie beim printf

segment data use32 class=data
    a dd 0                       ; in a wird der erster Zahl gespeichert (von Tast. gelesen)
    b dd 0                       ; in b wird der zweiter Zahl gespeichert (von Tast. gelesen)
    messageA db "a=", 0
    messageB db "b=", 0
    messageAB db "a+b=", 0
    format16 db "%x", 0         ; Basis 16
    format10 db "%d", 0         ; Basis 10

segment code use32 class=code
    start:
        ; Lese zwei Zahlen a und b (in der Basis 16) von der Tastatur und berechne a+b. Zeige das Ergebniss in Basis 10 an.
        
        ; Druckt 'a='
        push dword messageA     ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*1            ; freit 1 Parameter auf der Stack
        
        ; Liest a
        push dword a            ; die Adresse wird auf den Stack gelegt
        push dword format16     ; die Adresse wird auf den Stack gelegt
        call [scanf]            ; ruft die Funktion
        add esp, 4*2            ; freit 2 Parameter auf der Stack
        
        ; Druckt 'b='
        push dword messageB     ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*1            ; freit 1 Parameter auf der Stack
        
        ; Liest b
        push dword b            ; die Adresse wird auf den Stack gelegt
        push dword format16     ; die Adresse wird auf den Stack gelegt
        call [scanf]            ; ruft die Funktion
        add esp, 4*2            ; freit 2 Parameter auf der Stack
        
        ; Druckt 'a+b='
        push dword messageAB    ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*1            ; freit 1 Parameter auf der Stack
        
        ; Fuhrt die Addition
        mov eax, dword[a]
        mov ebx, dword[b]
        add eax, ebx
        
        ; Druckt die Summe
        push dword eax          ; die Adresse wird auf den Stack gelegt
        push dword format10     ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*2            ; freit 2 Parameter auf der Stack
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
