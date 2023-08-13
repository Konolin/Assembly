bits 32

global start
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    a dd 113
    b dd 5
    format db "a mod b = %d", 0 ;%d <=> decimal number

segment code use32 class=code
    start:
        ; Zwei natürliche Zahlen a und b (a,b : Doppelwörter, definiert im Datensegment) werden gegeben. Berechne a/b und zeige den Rest im folgenden Format auf dem Bildschirm an: "<a> mod <b> = <Rest>"

        mov eax, [a] ;speichern a in eax
        cdq ;konvertieren zu quadwort
        idiv dword [b] ;divisieren mit b

        push dword eax
        push dword format
        call [printf]
        add esp, 4 * 2
     

    push    dword 0
    call    [exit]
