;.model small
;.stack 100h
;.data
;    inv_Id DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
;    inv_name    DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
;         "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
;    inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
;    inv_price    dd 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200   ;price
;    totalIntPrice dd 0
;    totalFloatPrice dd 0
;    inv_priceBuffer db 4
;.code
;
;main proc 
;    mov ax,@data
;    mov ds,AX
;
;call getTotalPrice
;
;    mov ah,4ch
;    int 21h
;
;main ENDP
;
;getTotalPrice proc
;    lea si,inv_price
;    ;xor ax,AX
;    ;xor bx,bx
;    ;mov cx,10
;;
;    ;mov bx,100
;
;    mov dx,[si]
;    mov ah,09h
;    int 21h
;
;    ret
;
;
;
;getTotalPrice endp
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;END main

.model small
.stack 100h
.data
    num dw 10000          ; Define 10000 as a 16-bit number
    result dw ?           ; Storage for the result

.code
main proc
    mov ax, @data         ; Initialize data segment
    mov ds, ax

    ; Load 10000 into AX
    mov ax, num           ; Load 10000 into AX

    ; Divide AX by 2
    mov bx, 2             ; Set divisor (2) in BX
    div bx                ; Divide AX by BX (AX / BX)

    ; Store the result
    mov result, ax        ; Result of division stored in result

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp
end main

