.model small
.stack 100h
.data
    number dw 1234, 3000            ; The decimal number we want to convert
    buffer db 6 dup(?)        ; Buffer to store the ASCII result (max 5 digits + null terminator)
    newline db 0Dh, 0Ah, '$'  ; Carriage return + linefeed for formatting (DOS new line)

.code
main:
    mov ax, @data           ; Initialize the data segment
    mov ds, ax

    ; Convert the number to an ASCII string
    mov ax, number+2          ; Load the number into AX
    lea di, buffer + 5      ; Set DI to point to the end of the buffer (space for 5 digits)
    mov byte ptr [di], '$'  ; End string with a DOS terminator ('$')
    dec di                  ; Move DI to point to the first free spot

ConvertLoop:
    xor dx, dx              ; Clear DX before division (DX:AX is the dividend)
    mov bx, 10              ; Dividing by 10 to extract the least significant digit
    div bx                  ; AX / 10, result in AX (quotient), remainder in DX (remainder is the digit)
    add dl, '0'             ; Convert the remainder to ASCII by adding '0' (48)
    mov [di], dl            ; Store the ASCII character in the buffer
    dec di                  ; Move the pointer to the next position
    test ax, ax             ; Check if the quotient (AX) is 0 (done converting all digits)
    jnz ConvertLoop         ; If AX is not zero, continue

    ; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    ; Print a new line
    mov ah, 09h             ; DOS interrupt to display string
    lea dx, newline         ; Point to the new line string
    int 21h                 ; Call DOS interrupt

    ; Exit program
    mov ah, 4Ch             ; DOS function to terminate the program
    int 21h                 ; Call DOS interrupt

end main