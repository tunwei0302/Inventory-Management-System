.model small
.stack 100h

.data
invSize equ 200 ; SIZE OF STOCK
inv_Id DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
inv_name DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
         "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
inv_quantity DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
inv_price DW 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200 ;price

prompt db 'Enter item ID to restock: $', 0
invalid db 'Invalid item ID!$'
newline db 13, 10, '$'

header db "ID", 9, "NAME", 9, "QUANTITY", 9, "PRICE", 13, 10, '$'

exit_flag db 0

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

main_loop:
    ; Check exit flag
    cmp byte ptr [exit_flag], 1
    je end_program

    ; Display inventory
    call display_inventory

    ; Prompt user to enter item ID
    lea dx, prompt
    call print_string

    ; Read user input
    call read_number
    mov bx, ax ; Store user input in BX

    ; Validate input
    cmp bx, 0
    jl invalid_input
    cmp bx, 9
    jg invalid_input

    ; Update quantity
    mov si, bx
    shl si, 1 ; Multiply by 2 to get word offset
    add [inv_quantity + si], 1

    ; Set exit flag to 1 to exit the loop
    mov byte ptr [exit_flag], 1

    ; Display updated inventory
    call display_inventory

    ; End program
    jmp main_loop

invalid_input:
    lea dx, invalid
    call print_string
    call print_newline
    jmp main_loop

end_program:
    ; End program
    mov ah, 4Ch
    int 21h

main endp

display_inventory proc
    ; Print table header
    lea dx, header
    call print_string

    ; Initialize index
    mov cx, 10 ; Number of items
    mov si, 0  ; Index for item arrays

print_loop:
    ; Print item ID
    mov ax, [inv_Id + si]
    call print_number
    call print_tab

    ; Print item name
    mov bx, si
    mov ax, 20
    mul ax
    lea dx, inv_name
    add dx, ax
    call print_string
    call print_tab

    ; Print item quantity
    mov ax, [inv_quantity + si]
    call print_number
    call print_tab

    ; Print item price
    mov bx, si
    shl bx, 1
    mov ax, [inv_price + bx]
    call print_number
    call print_newline

    ; Increment index
    add si, 2 ; Each item is 2 bytes (word)
    loop print_loop

    ret
display_inventory endp

print_string proc
    mov ah, 09h
    int 21h
    ret
print_string endp

print_number proc
    ; Convert number to string and print
    ; (This is a simplified version, assumes number < 10000)
    mov bx, 10
    xor cx, cx

convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convert_loop

print_digits:
    pop dx
    mov ah, 02h
    int 21h
    loop print_digits

    ret
print_number endp

print_dword proc
    ; Print the lower 16 bits
    push dx
    call print_number
    pop dx

    ; Print the upper 16 bits
    call print_number
    ret
print_dword endp

print_tab proc
    mov dl, 9 ; ASCII code for tab
    mov ah, 02h
    int 21h
    ret
print_tab endp

print_newline proc
    mov dl, 13 ; Carriage return
    mov ah, 02h 
    int 21h
    mov dl, 10 ; Line feed
    mov ah, 02h
    int 21h
    ret
print_newline endp

read_number proc
    ; Read a single digit number from user input
    mov ah, 01h
    int 21h
    sub al, '0'
    cbw
    ret
read_number endp

end main