bits 32

global start
extern exit, printf, scanf              
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    a dd 0 
    b dd 0
    message1 db "a=", 0
    message2 db "b=", 0
    format db "%d", 0 ;dezimal Nummer
    result resd 1 

segment code use32 class=code
    start:
        ; Lese zwei Zahlen a und b (in der Basis10) von der Tastatur und berechne a/b. Dieser Wert wird in einer Variablen namens "result" (definiert im Datensegment) gespeichert. Die Werte werden in vorzeichenbehafteter Darstellung betrachtet.
        
        ;wird printf(message1) aufrufen => wird "a=" ausdrucken
        push dword message1;Adresse der Zeichenfolge auf dem Stapel, kein Wert
        call [printf];Aufruf von Funktion printf zum Drucken
        add esp, 4*1;wir befreien Parameter auf dem Stack: 4=Größe von dword; 1=Anzahl Parameter
        
        ;wird scanf(format,a) aufrufen => liest eine Zahl in die Variable a
        push dword a ;Adresse von a, kein Wert
        push dword format
        call [scanf];Aufruf von Funktion scanf zum Lesen
        add esp, 4*2;wir befreien Parameter auf dem Stack: 4=Größe von dword; 2=Anzahl Parameter
        
        ;wird printf(message2) aufrufen => wird "b=" ausdrucken
        push dword message2;Adresse der Zeichenfolge auf dem Stapel, kein Wert
        call [printf];Aufruf von Funktion printf zum Drucken
        add esp, 4*1;wir befreien Parameter auf dem Stack: 4=Größe von dword; 1=Anzahl Parameter
        
        ;wird scanf(format,b) aufrufen => liest eine Zahl in die Variable b
        push dword b;Adresse von b, kein Wert
        push dword format
        call [scanf];Aufruf von Funktion scanf zum Lesen
        add esp, 4*2;wir befreien Parameter auf dem Stack: 4=Größe von dword; 2=Anzahl Parameter
        
        mov eax, [a]; wir speichern a in eax
        cdq ;Konvertierung zu Quadwort---> edx:eax = a 
        idiv dword [b] ;eax = a/b
        mov [result], eax ;wir speichern eax in Datensegment result
        
        push    dword 0
        call    [exit]
