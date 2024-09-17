.model small

.stack 100h

.data
    ; Define the restock level
    restock_level dw 1000  ; Change to dw for 16-bit value

    ; Define the current stock level
    current_stock dw 50    ; Change to dw for consistency

    ; Define messages
    prompt_action db 0Dh, 0Ah, 'Enter A to add stock or R to reduce stock: $'
    prompt_amount db 0Dh, 0Ah, 'Enter the amount: $'
    newline db 0Dh, 0Ah, '$'
    input_buffer db 5, 0, 0, 0, 0, 0  ; Buffer for input (max 4 digits + null terminator)
    stock_msg db 0Dh, 0Ah, 'Current stock level: $'
    stock_buffer db 6, 0, 0, 0, 0, 0, 0  ; Buffer for stock level string
    ten dw 10  ; Define ten before it is used

.code
main PROC
    ; Set up the data segment
    mov ax, @data
    mov ds, ax

    ; Print the initial stock level
    call print_stock_level

    ; Prompt the user for an action
    lea dx, prompt_action
    mov ah, 09h
    int 21h

    ; Read the user's action
    mov ah, 01h
    int 21h
    mov bl, al  ; Store the action in bl

    ; Prompt the user for the amount
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, prompt_amount
    mov ah, 09h
    int 21h

    ; Read the amount (multi-digit)
    lea dx, input_buffer
    mov ah, 0Ah
    int 21h

    ; Convert input string to number
    call convert_input_to_number

    ; Update the current stock based on the action
    cmp bl, 'A'
    je add_stock
    cmp bl, 'R'
    je reduce_stock

    ; Invalid action, exit the program
    jmp exit_program

add_stock:
    ; Add the amount to the current stock
    call add_to_stock
    call print_stock_level
    jmp check_restock

reduce_stock:
    ; Reduce the amount from the current stock
    call reduce_from_stock
    call print_stock_level
    jmp check_restock

check_restock:
    ; Compare current stock with restock level
    mov ax, restock_level
    mov bx, current_stock
    cmp bx, ax
    jl restock

exit_program:
    ; Exit the program
    mov ah, 4Ch         ; DOS function: terminate program
    xor al, al          ; status: 0
    int 21h

restock:
    ; Restock the inventory
    mov ax, restock_level
    mov current_stock, ax
    call print_stock_level
    jmp exit_program

convert_input_to_number PROC
    ; Convert input string to number
    lea si, input_buffer + 1  ; Skip the first byte (length of input)
    xor ax, ax                ; Clear ax
    xor bx, bx                ; Clear bx
convert_loop:
    mov cl, [si]
    cmp cl, 0Dh               ; Check for carriage return (end of input)
    je convert_done
    sub cl, '0'               ; Convert ASCII to number
    mov cx, 10
    mul cx                    ; Multiply ax by 10
    add ax, cx                ; Add the digit
    inc si                    ; Move to the next character
    jmp convert_loop
convert_done:
    mov bh, al                ; Store the amount in bh
    ret
convert_input_to_number ENDP

add_to_stock PROC
    ; Add the amount to the current stock
    mov ax, current_stock
    add ax, bx
    mov current_stock, ax
    ret
add_to_stock ENDP

reduce_from_stock PROC
    ; Reduce the amount from the current stock
    mov ax, current_stock
    sub ax, bx
    mov current_stock, ax
    ret
reduce_from_stock ENDP

print_stock_level PROC
    ; Print the current stock level
    lea dx, stock_msg
    mov ah, 09h
    int 21h

    ; Convert current stock to string
    mov ax, current_stock
    lea di, stock_buffer + 5
    mov byte ptr [di], '$'
    dec di
convert_stock_to_string:
    xor dx, dx
    div word ptr [ten]
    add dl, '0'
    mov [di], dl
    dec di
    cmp ax, 0
    jne convert_stock_to_string

    ; Print the stock level string
    lea dx, stock_buffer
    mov ah, 09h
    int 21h
    ret
print_stock_level ENDP

main ENDP
END main