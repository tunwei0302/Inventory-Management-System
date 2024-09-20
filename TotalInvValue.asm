.model small
.stack 100h
.data
    inv_Id DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
    inv_name    DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
         "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
    inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
    inv_price    dw 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200   ;price
    totalIntPrice dw 0
    totalFloatPrice dw 0
    inv_priceBuffer dw 2
    inv_quantityBuffer dw 2
    buffer db 6 dup(?)
.code

main proc 
    mov ax,@data
    mov ds,AX

    call getTotalPrice


    mov ax,totalIntPrice
    call printPrice

    xor ax,ax
    mov dx,2eh
    mov ah,02h    
    int 21h

    mov ax,totalFloatPrice
    call printPrice

    mov ah,4ch
    int 21h

main ENDP

getTotalPrice proc
    mov cx,0

addTotal:
    
    lea si,inv_quantityBuffer
    mov ax,[si]
    mul cx
    
    xor bx,bx

    lea si,inv_quantity
    add si,ax
    mov bx,[si]

    xor ax,ax
    lea si,inv_priceBuffer
    mov ax,[si]
    mul cx

    lea si,inv_price
    add si,ax
    mov ax,[si]

    mul bx

    xor bx,bx
    mov bx,100
    div bx

    add totalIntPrice,ax
    add totalFloatPrice,dx
    inc cx
    cmp cx,10
    jne addTotal

    xor ax,ax
    xor dx,dx

    lea si,totalFloatPrice
    mov dx,[si]
    mov ax,dx
    xor dx,dx
    mov bx,100
    div bx
    


    add totalIntPrice,ax
    mov totalFloatPrice,dx

    ret
getTotalPrice endp

printPrice proc
;convert to string
    mov buffer,0
    lea di,buffer+5
    mov byte ptr [di],'$'
    dec di

convert_loop:
    xor dx, dx              ; Clear DX before division (DX:AX is the dividend)
    mov bx, 10              ; Dividing by 10 to extract the least significant digit
    div bx                  ; AX / 10, result in AX (quotient), remainder in DX (remainder is the digit)
    add dl, '0'             ; Convert the remainder to ASCII by adding '0' (48)
    mov [di], dl            ; Store the ASCII character in the buffer
    dec di                  ; Move the pointer to the next position
    test ax, ax             ; Check if the quotient (AX) is 0 (done converting all digits)
    jnz convert_loop         ; If AX is not zero, continue
    
    ; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    ret
printPrice endp












END main
