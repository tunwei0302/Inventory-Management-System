.model small
.stack 100h
.data
    ; Define stock levels
    restock_level dw 1000      ; Restock level threshold
    max_stock dw 2000          ; Maximum stock level
    current_stock dw 50        ; Current stock level

    ; Define messages
    prompt_action db 0Dh, 0Ah, 'Enter A to add stock or R to reduce stock: $'
    prompt_amount db 0Dh, 0Ah, 'Enter the amount (1-999): $'
    invalid_action_msg db 0Dh, 0Ah, 'Invalid action, please try again.$'
    invalid_amount_msg db 0Dh, 0Ah, 'Invalid amount, please enter a value between 1 and 999.$'
    stock_msg db 0Dh, 0Ah, 'Current stock level: $'
    stock_buffer db 6, 0, 0, 0, 0, 0, 0  ; Buffer for stock level string
    ten dw 10
    newline db 0Dh, 0Ah, '$'

    ; Buffers
    input_buffer db 5, 0, 0, 0, 0, 0  ; Buffer for input (max 4 digits + null terminator)

.code
 ; ------------------------------------Restock Page------------------------------------
    main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Main loop
    main_loop:
        call print_stock_level ; Print the current stock level
        call prompt_user_action ; Prompt user for an action (Add or Reduce)
        call prompt_user_amount ; Prompt user for the amount to add or reduce
        call update_stock ; Update the stock level based on user input

        jmp main_loop ; Go back to main loop for continuous stock management


    ; Exit the program
    exit_program:
        mov ah, 4Ch ; Exit program
        xor al, al ; Return code 0
        int 21h 

    ; Prompt the user for an action (Add or Reduce)
    prompt_user_action PROC
        lea dx, prompt_action ; Load prompt message
        mov ah, 09h ; Display string function
        int 21h 

        ; Get user input
        mov ah, 01h ; Read character from standard input
        int 21h ; Store input in AL
        mov bl, al  ; Store action in bl (A for Add, R for Reduce)

        ; Validate input
        cmp bl, 'A'
        je action_valid
        cmp bl, 'R'
        je action_valid

        ; Invalid action
        lea dx, invalid_action_msg
        mov ah, 09h
        int 21h
        jmp prompt_user_action  ; Re-prompt

        ; Return if action is valid
        action_valid:
        ret 
    prompt_user_action ENDP

    ; Prompt the user for the amount to add or reduce
    prompt_user_amount PROC
        ; Prompt the user for the amount
        lea dx, newline
        mov ah, 09h
        int 21h
        lea dx, prompt_amount
        mov ah, 09h
        int 21h

        ; Read the input string
        lea dx, input_buffer
        mov ah, 0Ah ; Buffered input
        int 21h

        ; Convert the input string to a number
        call string_to_number

        ; Validate the number (assuming max stock level is 9999)
        cmp ax, 0
        jl invalid_amount
        cmp ax, 9999
        jg invalid_amount

        ret

    invalid_amount:
        lea dx, invalid_amount_msg
        mov ah, 09h
        int 21h
        jmp prompt_user_amount

    prompt_user_amount ENDP

    ; Convert string in input_buffer to a number in AX
    string_to_number PROC
        mov si, offset input_buffer + 1 ; SI points to the first digit
        xor ax, ax ; Clear AX (result)
        xor cx, cx ; Clear CX (multiplier)

    convert_loop_1:
        mov bl, [si] ; Load the current character
        cmp bl, 0Dh ; Check for carriage return (end of input)
        je end_convert
        sub bl, '0' ; Convert ASCII to digit
        mov cx, 10
        mul cx ; Multiply AX by 10
        add ax, bx ; Add the digit to AX
        inc si ; Move to the next character
        jmp convert_loop_1

    end_convert:
        ret
    string_to_number ENDP


    ; Update the stock level based on user input
    update_stock PROC
        ; Check if the user wants to add or reduce stock
        cmp bl, 'A'
        je add_stock
        cmp bl, 'R'
        je reduce_stock
        
        ret ; Default to return if no valid action

        add_stock:
            ; Add amount to current stock, check against max stock
            mov ax, current_stock
            add ax, bx
            cmp ax, max_stock
            jg stock_overflow

            mov current_stock, ax
            ret

        stock_overflow:
            ; Set stock to max if overflow
            mov ax, max_stock
            mov current_stock, ax
            ret

        reduce_stock:
            ; Reduce amount from current stock, prevent negative stock
            mov ax, current_stock
            sub ax, bx
            jl stock_underflow

            mov current_stock, ax
            ret 

        stock_underflow:
            ; Set stock to zero if underflow
            mov current_stock, 0
            ret
        update_stock ENDP

        convert_input_to_number PROC
            ; Convert the input buffer string to a number
            lea si, input_buffer + 1  ; Skip the first byte (input length)
            xor ax, ax
            xor bx, bx

        convert_loop:
            ; Loop through the input buffer
            mov cl, [si]
            cmp cl, 0Dh
            je convert_done
            sub cl, '0'
            mov cx, 10
            mul cx
            add ax, cx
            inc si
            jmp convert_loop

        convert_done:
            ; Store the converted number in BX
            mov bx, ax
            ret
        convert_input_to_number ENDP

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
            ; Convert stock level to string
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
