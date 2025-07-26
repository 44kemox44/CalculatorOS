[org 0x7c00]              

top:
    mov si, message
    call print_string

    cli                    ; CPU'yu durdur
    hlt

print_string:
    lodsb                 ; AL <- [SI], SI++
    or al, al             ; AL == 0 ?
    jz .done
    mov ah, 0x0E          ; BIOS teletype
    int 0x10              ; yaz ekrana
    jmp print_string
.done:
    ret

message db "CalculatorOS booted!", 0

times 510 - ($ - $$) db 0 ; 510 byte tamamla
    dw 0xAA55              ; boot signature
