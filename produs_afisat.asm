bits 32

global start
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    a dd -15d
    b dd 15d
    zeichnen db " %d * %d = %d"

segment code use32 class=code
    start:
        mov ecx, [a]        ;ecx = a
        mov ebx, [b]        ;ebx = b
        mov eax, [a]        ;eax = a
        mul ebx             ;edx:eax = a * b
        
        push dword eax      ;eax = ergebniss
        push dword ebx      ;ebx = b
        push dword ecx      ;ecx = a
        push dword zeichnen ;zeichnen ist die Fromat fur die bildschirm
        call [printf]       ;printf sodass wir die Ergebniss im Bildschirm sehen
        add esp, 4 * 4      ;loschen die parameter vom Stack
        
        ; exit(0)
        push    dword 0
        call    [exit]
