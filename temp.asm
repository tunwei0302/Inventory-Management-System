.model small

.stack

.data
    asciiArt1 db '       _                 $'
              db '     _|=|__________      $'
              db '    /              \     $'
              db '   /                \    $'
              db '  /__________________\   $'
              db '   ||  || /--\ ||  ||    $'
              db '   ||[]|| | .| ||[]||    $'
              db ' ()||__||_|__|_||__||()  $'
              db '( )|-|-|-|====|-|-|-|( ) $'
              db '^^^^^^^^^^====^^^^^^^^^^^',13,10,'$' ;25 byte per row, 10 col
    menuHead db 'Sinaran Inventory Management System',13,10,'$'
    currentDate db 'Date: $'
    currentTime db 'Time: $'
    currentDayOfWeek db 'Day: $'
    daysOfWeek db 'Sunday   $', 'Monday   $', 'Tuesday  $', 'Wednesday$', 'Thursday $', 'Friday   $', 'Saturday $'
    lineCount db 0
    ascii_Buffer db 26 dup(1)

    ; Login
    username        db "admin$", 0 
    password        db "1234$", 0

    input_username  db 20
                    db 0 
                    db 20 dup(0)

    input_password  db 20
                    db 0 
                    db 20 dup(0)

    loginheader     db 13, 10, '+============================+'
                    db 13, 10, '         Login Menu'
                    db 13, 10, '+============================+$'

    username_prompt db 13, 10, "Enter Username [Enter E to Exit]: $"
    password_prompt db 13, 10, "Enter Password: $"
    
    success_msg     db 13, 10, 'Login successful!$'
    fail_msg        db 13, 10, 'Login failed! Try again.$'

    exit_con        db 13, 10, 'Are you sure you want to EXIT THE SYSTEM !!! [Y=yes : N=No]: $'

    ; Inventory 
    invSize             equ 200 ; SIZE OF STOCK
        inv_Id          DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
        inv_name        DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
             "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
        inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
        inv_price       dd 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200   ;price
    
    current_item_count db 10d

    ; Main Menu
    mainMenuOption      db 13,10,' Inventory Management System ',13,10
                        db '+=============================+',13,10
                        db '1. Restock',13,10
                        db '2. Sell item',13,10
                        db '3. Edit item',13,10
                        db '4. Calculate Total',13,10
                        db '5. Logout', 13, 10
                        db 'Enter your choice > $'
    inputError          db 13,10,'Input Invalid! Please try again later.',13,10,'$'
    sellItemMenu        db 13,10,'==========================='
                        db 13,10,'        SELLING MENU'
                        db 13,10,'===========================',13,10,'$'
    enterChoice db 13,10,'Enter your choice > $'
    sellItem_jumpTable db ''

    ; Edit Item
    edit_menu           db 13, 10, '+==========+==========+'
                        db 13, 10, '    Edit Items Menu'
                        db 13, 10, '+==========+==========+'
                        db 13, 10, '1. Edit Item Name'
                        db 13, 10, '2. Edit Item Price'
                        db 13, 10, '3. Edit Item Quantity'
                        db 13, 10, '4. Add Item'
                        db 13, 10, '5. Delete Item'
                        db 13, 10, '6. Return'
                        db 13, 10, 'Enter your choice > $'

    prev_name           db 13, 10, 'Item Previous Name: $'
    new_name            db 13, 10, 'Item New Name: $'

    item_selected       db 13, 10, 'Item selected: $'
    prev_price          db 13, 10, 'Previous Price: $'
    new_price           db 13, 10, 'New Price: $'

    prev_quantity       db 13, 10, 'Previous Quantity: $'
    new_quantity        db 13, 10, 'New Quantity: $'

    add_item_name       db 13, 10, 'New Item Name: $'
    add_item_price      db 13, 10, 'New Item Price: $'
    add_item_quantity   db 13, 10, 'New Item Quantity: $'

    delete_item         db 13, 10, 'Delete Item: '
                        db 13, 10, 'Enter Item No you wish to DELETE: $'

    input_con           db 13, 10, 'Confirm Action [Y=yes : N=No]: $'
    delete_con          db 13, 10, 'Are You Sure You Want To DELETE This Item!! [Y=yes : N=No]: $'

    temp_name           db 20
                        db 0 
                        db 20 dup(0)

    buffer db 20 dup('$')
    input_error db 13, 10, 'Input Error ! Please Try Again !!$'
    press_enter db 13, 10, '+----- Press Enter to Continue -----+$' 
    new_line db 13, 10, '$'
    output_msg db 0Dh, 0Ah, 'Updated Item List: $'
.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

start:
    call clearScreen
    ; mov ah, 09h

    ; lea dx, new_line
    ; int 21h

    ; lea dx, inv_name 
    ; int 21h

    ; lea dx, inv_name+20
    ; int 21h

    ; lea dx, inv_name+40
    ; int 21h

    ; lea dx, new_line
    ; int 21h

    mov ah, 0Ah
    lea dx, temp_name
    int 21h

     ; Replace "PENCIL" in inv_name
    lea si, temp_name + 2      ; Point to the new name (after length byte)
    lea di, inv_name           ; Point to the start of inv_name
    mov al, [temp_name+1]                 ; Number of characters to copy (length of "PENCIL")
    xor ah, ah
    mov cx, ax
    ; Copy new name to inv_name
copy_loop:
    mov al, [si]               ; Load byte from temp_name
    mov [di], al               ; Store byte in inv_name
    inc si                     ; Move to next character in temp_name
    inc di                     ; Move to next character in inv_name
    loop copy_loop              ; Repeat for all characters

    ; Fill remaining space with spaces
    mov cx, 1                 ; Total length of "PENCIL"
fill_spaces:
    mov al, ' '                ; Load space character
    mov [di], al               ; Store space character in inv_name
    inc di                     ; Move to the next character
    loop fill_spaces           ; Repeat until filled

    ; Add dollar sign at the end
    mov al, '$'
    mov [di], al               ; Store dollar sign

    ; Print updated item list
    mov ah, 09h
    lea dx, output_msg
    int 21h

    ; Print inv_name to show the updated list
    mov ah, 09h
    lea dx, inv_name
    int 21h

    mov ah, 09h
    lea dx, inv_name
    int 21h
    
    lea dx, new_line
    int 21h

    mov ah, 01h
    int 21h
    jmp start
    ; Exit program
    mov ax, 4C00h
    int 21h

exceed_length:
    ; Handle error (e.g., display a message or just return to the main prompt)
    ; For simplicity, just exit in this example
    mov ax, 4C00h
    int 21h

endp

ClearScreen proc
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 10h

    ret
ClearScreen endp

end main