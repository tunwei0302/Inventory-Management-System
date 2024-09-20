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
        inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 15, 1, 23 ;quantity
        inv_price       dw 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200   ;price

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

    ; ------------------------------- Restock -------------------------------
    restockMenu         db 13, 10, '+============================+'
                        db 13, 10, '         RESTOCK MENU'
                        db 13, 10, '+============================+',13,10,'$'
    res_table_heading db 13, 10, 'Name                  Quantity    Price', 13, 10, '-----------------------------------------', 13, 10, '$'
    res_enterChoice     db 13,10,'Enter your choice of item to restock > $'
    res_enterQuantity        db 13,10,'Enter Quantity to restock (1 - 99) > $'
    res_invalid_amount_msg   db 13,10,'Invalid amount, please enter a value between 1 and 99.$'
    res_msg_current_stock db 'Current Stock for ', 0, '$'
    res_msg_colon db ': ', 0, '$'
    tempResQty DW ? 
    res_exceed_max_stock_msg db 'Exceeds max stock. Please enter a valid amount.', 13, 10, '$'
    res_invalid_item_id_msg db 'Invalid item ID. Please enter an ID between 1 and 10.', 13, 10, '$'
    res_max_stock dw 100


    sellItemMenu        db 13,10,'==========================='
                        db 13,10,'        SELLING MENU'
                        db 13,10,'===========================$'
    sellItemMenuOption  db 13,10,'1. Sell Item'
                        db 13,10,'2. Exit To Main Menu $'
    enterChoice db 13,10,'Enter your choice > $'
    exitSellItem    db '11.Exit',13,10,'$'
    enterSellItem   db 13,10,'Enter Item No > $'
    enterQuantity db 13,10,'Enter Sell Quantity (1 - 99) > $'
    totalProfit db 13,10,'Total Profit > $'
    sellItem_jumpTable db ''
    tempInvQty DW ?
    tempInvIndex dw ?
    sellAmount dw ?
    invHead db 'ID  NAME          QUANTITY   PRICE',13,10,'$'
    totalPrice db 'Total Price > $'
    totalIntPrice dw 0
    totalFloatPrice dw 0
    inv_priceBuffer dw 2
    inv_quantityBuffer dw 2
    priceBuffer db 6 dup(?)

    ; Edit Item
    edit_menu           db 13, 10, '+==========+==========+'
                        db 13, 10, '    Edit Items Menu'
                        db 13, 10, '+==========+==========+'
                        db 13, 10, '1. Edit Item Name'
                        db 13, 10, '2. Edit Item Quantity'
                        db 13, 10, '3. Return'
                        db 13, 10, 'Enter your choice > $'

    en_header           db 13, 10, '+==========+==========+'
                        db 13, 10, '       Edit Name'
                        db 13, 10, '+==========+==========+$'
    prev_name           db 13, 10, 'Item Previous Name: $'
    new_name            db 13, 10, 'Item New Name [Enter R to Return]: $'

    eq_header           db 13, 10, '+==========+==========+'
                        db 13, 10, '       Edit Quantity'
                        db 13, 10, '+==========+==========+$'
    new_quantity        db 13, 10, 'New Quantity [0-99] [Enter R to Return]: $'
    quantity_range      db 13, 10, 'Please Enter Quantity between [0 - 99]$'

    input_con           db 13, 10, 'Confirm Action [Y=yes : N=No]: $'

    temp_name           db 20
                        db 0 
                        db 20 

    buffer db 20 dup('$')
    input_buffer db 10 dup('$')

    prompt_selectNo     db 13, 10, 'Select Item No [1 - 10] [Enter R to Return]: $'
    input_exit  db 13,10,'Exiting... $'
    input_error db 13, 10, 'Input Error ! Please Try Again !!$'
    press_enter db 13, 10, '+----- Press Enter to Continue -----+$' 
    new_line db 13, 10, '$'
    count dw ?
    temp dw ?
.code
main proc

    mov ax, @data
    mov ds, ax
    
    start:
        call loginPage
        cmp al, 0
        je exit

        call menu
        jmp start
    
    exit:
        mov ah,4ch
        int 21h

main endp

loginPage proc
    login:
        call printHeader
        ; Clear username buffer
        lea di, input_username + 2       ; Point to the start of the input buffer
        mov cx, 20                       ; Set CX to the size of the buffer (20 bytes)
        call clear_login_buffer

        ; Clear password buffer
        lea di, input_password + 2       ; Point to the start of the password buffer
        mov cx, 20                       ; Set CX to the size of the buffer (20 bytes)
        call clear_login_buffer

        mov dx, offset loginheader       ; Print Login Header
        call PrintString
        jmp enter_name

    validate_login:               
        ; Check username
        lea si, [username]               ; Load address of stored username into SI
        lea di, [input_username+2]       ; Load address of input username into DI
        call checkLogin
        cmp al, 0                        ; Check if return value is 0 (failure)
        je login

        ; Check password
        lea si, [password]               ; Load address of stored password into SI
        lea di, [input_password+2]       ; Load address of input password into DI
        call checkLogin
        cmp al, 0                        ; Check if return value is 0 (failure)
        je login

        mov dx, offset success_msg       ; Print Successful Login msg
        call PrintString
        call double_new_line

        call system_pause
        mov al, 1
        ret

    exit_confirmation:                   ; Check User Exit Confirmation
        mov dx, offset exit_con
        call PrintString
        mov ah, 01H
	    int 21H    
        cmp al, "Y"
        je exit_login
        cmp al, "y"
        je exit_login
        cmp al, "N"
        je login
        cmp al, "n"
        je login
        jne wrong_input

    enter_name:
        mov dx, offset username_prompt   ; Prompt for username
        call PrintString

        mov ah, 0Ah
        lea dx, input_username
        int 21h

        ; Add null terminator for username input
        mov al, [input_username+1]       ; Number of characters entered is at input_user+1
        xor ah, ah
        lea si, [input_username+2]       ; Point to the first character of the input
        add si, ax                       ; Move to the end of the entered username
        mov byte ptr [si], '$'           ; Add the '$' to terminate the string

        cmp [input_username+2], 'E'
        je exit_confirmation
        cmp [input_username+2], 'e'
        je exit_confirmation

    enter_password:
        mov dx, offset password_prompt   ; Prompt for password
        call PrintString

        mov ah, 0Ah
        lea dx, input_password
        int 21h

        ; Add null terminator for password input
        mov al, [input_password+1]       ; Number of characters entered is at input_password+1
        xor ah, ah
        lea si, [input_password+2]       ; Point to the first character of the input
        add si, ax                       ; Move to the end of the entered username
        mov byte ptr [si], '$'           ; Add the '$' to terminate the string

        jmp validate_login

    wrong_input:                         ; Print Input Error Msg for User to Know 
        mov dx, offset input_error
        call PrintString
        
        call double_new_line
        jmp exit_confirmation

    exit_login:
        mov al,0
        ret
loginPage endp

checkLogin proc
    cld
    mov cx, 20                ; Set a reasonable maximum length for comparison
    compare_loop:
        mov al, [si]              ; Load byte from str1 into AL
        mov bl, [di]              ; Load byte from str2 into BL
        cmp al, bl                ; Compare the two characters
        jne failed                ; If characters differ, strings are not equal
        cmp al,'$'               ; Check if we reached the null terminator (0)
        je equal                  ; If null terminator, strings matched
        inc si                    ; Move to the next character in str1
        inc di                    ; Move to the next character in str2
        loop compare_loop         ; Continue until CX reaches 0 (unnecessary for fixed length)

    equal:
        mov al, 1
        ret                       ; Return if strings match

    failed:
        ; Print failure message
        mov dx, offset fail_msg
        call PrintString
        call double_new_line

        call system_pause
        mov al, 0
        ret

checkLogin endp

menu proc
    menu1:
    call clearScreen
    lea dx,mainMenuOption
    mov ah,09h
    int 21h
    
    mov ah,01h
    int 21h

    sub al,'0'
    cmp al,1
    jne skip1
    jmp restock
skip1:
    cmp al,2
    jne skip2
    jmp sellItem
skip2:
    cmp al,3
    jne skip3
    call editMenu
    jmp menu1
skip3:
    cmp al,4
    jne skip4
    jmp calculateTotal
skip4:
    cmp al,5
    jne skip5
    ret
skip5:
    lea dx,[inputError]
    mov ah,09h
    int 21h
    jmp menu

menu endp

printHeader proc
    call ClearScreen

header:
    mov cx,10


    lea si,asciiArt1

    mov lineCount,5
AsciiLoop:

    mov ah,02h
    mov bh, 0
    mov dh, lineCount
    mov dl, 28
    int 10h


    lea dx,[si]
    call PrintString

    add si,26
    inc lineCount

    loop AsciiLoop

    mov ah,02h
    mov bh, 0
    mov dh, 15
    mov dl, 23
    int 10h

    lea dx,menuHead
    call PrintString
    
    call getDateTime

    ret


printHeader endp

restock proc
    call clearScreen

    lea dx, restockMenu
    mov ah, 09h ; Print the restock menu
    int 21h ; Call DOS interrupt
    
    call itemList

    lea dx, totalPrice
    mov ah, 09h
    int 21h

    call getTotalPrice

    xor ax, ax
    mov ax, totalIntPrice
    call printPrice

    xor ax, ax
    mov dx, 2eh
    mov ah, 02h    
    int 21h

    mov ax, totalFloatPrice
    call printPrice

enterItemID:
    lea dx, res_enterChoice
    mov ah, 09h
    int 21h

    lea dx, buffer
    mov ah, 0ah
    int 21h

    lea si, buffer+2
    xor ax, ax
    xor bx, bx
    mov cx, 10

    CALL convert_loop

    ; Validate the item ID (must be between 1 and 10)
    cmp ax, 1
    jl invalid_item_id
    cmp ax, 10
    jg invalid_item_id
    jmp valid_item_id

invalid_item_id:
    lea dx, input_error
    mov ah, 09h
    int 21h
    jmp enterItemID

valid_item_id:
    ; If valid, proceed with restocking
    sub ax, 1
    mov tempInvIndex, ax
    mov bx, 2
    lea si, inv_quantity
    mul bx
    add si, ax
    mov cx, [si]
    mov tempResQty, cx

    ; Enter the quantity to restock
res_enterQty:
    lea dx, res_enterQuantity
    mov ah, 09h
    int 21h

    lea dx, buffer
    mov ah, 0ah
    int 21h

    lea si, buffer+2
    xor ax, ax
    xor bx, bx
    mov cx, 10

    CALL convert_loop

    ; Validate the number (max stock level is 99)
    cmp ax, 1
    jl res_invalid_amount
    cmp ax, 99
    jg res_invalid_amount

    ; Change from subtracting to adding the quantity
    add tempResQty, ax

    ; Check if the updated stock exceeds max_stock
    mov bx, res_max_stock
    cmp tempResQty, bx
    jg res_exceed_max_stock

    CALL double_new_line

    ; Display current stock message
    lea dx, res_msg_current_stock
    mov ah, 09h
    int 21h

    ; Calculate the offset for the item name
    mov ax, tempInvIndex
    mov bx, 20 ; Assuming each name is 20 bytes long
    mul bx
    add ax, offset inv_name
    mov dx, ax

    ; Display the item name
    mov ah, 09h
    int 21h

    ; Display colon message
    lea dx, res_msg_colon
    mov ah, 09h
    int 21h

    ; Display updated quantity
    mov ax, tempResQty
    lea di, buffer + 5
    mov byte ptr [di], '$'
    dec di
    call Convertdb

    ; Print the result
    lea dx, [di+1]
    mov ah, 09h
    int 21h

    ; Save the updated quantity into the array
    mov ax, tempInvIndex
    mov bx, 2
    lea si, inv_quantity
    mul bx
    add si, ax
    mov ax, tempResQty
    mov [si], ax

    call double_new_line
    CALL system_pause

    ; Return to main menu
    call menu

    ret

res_invalid_amount:
    lea dx, res_invalid_amount_msg
    mov ah, 09h
    int 21h
    jmp res_enterQty

res_exceed_max_stock:
    lea dx, res_exceed_max_stock_msg
    mov ah, 09h
    int 21h
    jmp res_enterQty

restock endp

;Print Item List
itemList proc
    mov cx,10
    mov si,0
    lea dx,invHead
    lea dx, res_table_heading
    mov ah,09h
    int 21h

itemLists:

    mov bx,si
    inc bx

    cmp bx,9
    jle singleDigit
    mov dx,'1'
    mov ah,02h
    int 21h

    mov bx,0

singleDigit:

    mov dx,bx
    add dx,'0'
    mov ah,02h
    int 21h
    
    mov dx,2eh
    mov ah,02h
    int 21h

    mov ax,si
    mov bx,20
    mul bx

    lea dx,inv_name
    add dx,ax
    mov ah ,09h
    int 21h

    mov dx,9
    mov ah,02h
    int 21h

    xor bx,bx
    mov bx,2
    xor ax,ax
    mov ax,si
    mul bx
    
    mov count,si

    lea si,inv_quantity
    add si,ax
    xor ax,ax
    mov ax,[si]
    
    lea di, buffer + 5      
    mov byte ptr [di], '$'  
    dec di                  

    call Convertdb

; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    mov dx,9
    mov ah,02h
    int 21h

    xor bx,bx
    mov bx,2
    xor ax,ax
    mov ax,count
    mul bx

    lea si,inv_price
    add si,ax
    xor ax,ax
    mov ax,[si]
    mov bx,100
    div bx
    mov temp,dx


    lea di, buffer + 5      
    mov byte ptr [di], '$'  
    dec di                  


    call Convertdb
; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    mov dx,'.'
    mov ah,02h
    int 21h

    xor ax,ax
    mov ax,temp
    lea di, buffer + 5      
    mov byte ptr [di], '$'  
    dec di  
    
    call Convertdb
; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt 

    xor dx,dx
    xor ax,ax
    ;new line
    mov dx,13
    mov ah,02h
    int 21h
    mov dx,10
    int 21h

    mov si,count
    inc si
    dec cx
    cmp cx,0
    je skip6
    jmp itemLists
skip6:
    

    
    ret
itemList endp

;Sell Item Function
sellItem proc
    call clearScreen        ;Clear Screen

end_switch_sell:
    call ClearScreen
    lea dx,[sellItemMenu]
    mov ah,09h
    int 21h

    call itemList   ;Display Item list

    lea dx,[exitSellItem]
    mov ah, 09h            
    int 21h 

    xor dx,dx
    mov ah,9
    int 21h
    lea dx,totalPrice
    mov ah,09h
    int 21h

    call getTotalPrice

    xor ax,ax
    mov ax,totalIntPrice
    call printPrice
;
    xor ax,ax
    mov dx,2eh
    mov ah,02h    
    int 21h
;
    mov ax,totalFloatPrice
    call printPrice
    lea dx,[enterSellItem]
    mov ah,09h
    int 21h

    lea dx,buffer       ;get input
    mov ah,0ah
    int 21h

    lea si,buffer+2
    xor ax,ax
    mov cx,10
    xor bx,bx

    CALL convert_loop   ;convert ascii into numeric

    ;if 11 exit
    cmp ax,11
    je SELL2_EQUAL
    jne SELL2_NOT_EQUAL

SELL2_EQUAL:
    lea dx,[input_exit]
    mov ah, 09h            
    int 21h
    CALL double_new_line
    CALL system_pause
    jmp menu

SELL2_NOT_EQUAL:
    cmp ax, 0 ;find if is digit 
    jl SELL_INVALID
    cmp ax, 12
    jge SELL_INVALID
    jl SELL_VALID

SELL_INVALID:
    lea dx, input_error
    mov ah,09h
    int 21h
    CALL double_new_line
    CALL system_pause
    jmp end_switch_sell

SELL_VALID: ;continue
    sub ax,1
    mov tempInvIndex,ax
    mov bx,2
    lea si,inv_quantity
    mul bx
    add si,ax
    mov cx,[si]
    mov tempInvQty, cx

enterQty:   ;enter quantity
    lea dx,enterQuantity
    mov ah,09h
    int 21h

    lea dx,buffer
    mov ah,0ah
    int 21h

    lea si,buffer+2
    xor ax,ax
    xor bx,bx
    xor cx,cx
    mov cx,10

    CALL convert_loop

    ;max and min quantity validation
    cmp ax, 99  ;max
    jg SELL2_INVALID
    cmp ax, 1   ;min not less than 1
    jl SELL2_INVALID
    jmp SELL2_VALID

SELL2_INVALID:
    lea dx, input_error
    mov ah, 09H
    int 21h
    jmp enterQty

SELL2_VALID:
    cmp tempInvQty,ax ;check if sell quantity is higher than inv quantity
    jge qtySkip
    jmp invalidQty

qtySkip:

    sub tempInvQty, ax
    mov sellAmount,ax
    
    ;saving quantity into array
    xor ax,ax
    mov ax, [tempInvIndex]
    xor bx,bx
    mov bx,2
    lea si,inv_quantity
    mul bx
    add si,ax
    xor ax,ax
    mov ax, [tempInvQty]
    mov [si], ax

    ;saving quantity into array
    xor ax,ax
    mov ax, [tempInvIndex]
    mov bx,2
    lea si,inv_quantity
    mul bx
    add si,ax
    xor ax,ax
    mov ax, [tempInvQty]
    mov [si], ax

    ;print total profit
    xor ax,ax
    lea dx,totalProfit
    mov ah,09h
    int 21h

    xor bx,bx
    mov bx,2
    xor ax,ax
    mov ax,tempInvIndex
    mul bx

    lea si,inv_price
    add si,ax

    xor ax,ax
    mov ax,sellAmount
    xor bx,bx
    mov bx,[si]
    mul bx

    xor bx,bx
    mov bx,100
    div bx
    mov temp,dx

    lea di, priceBuffer + 5      
    mov byte ptr [di], '$'  
    dec di                  

    call Convertdb
; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    mov dx,'.'
    mov ah,02h
    int 21h

    xor ax,ax
    mov ax,temp
    lea di, priceBuffer + 5      
    mov byte ptr [di], '$'  
    dec di  
    
    call Convertdb
; Print the result
    lea dx, [di+1]          ; DX points to the first character of the converted number
    mov ah, 09h             ; DOS interrupt to print the string
    int 21h                 ; Call DOS interrupt

    call double_new_line
    CALL system_pause

    JMP end_switch_sell
    ret

invalidQty:
    lea dx, input_error
    mov ah, 09H
    int 21h
    jmp enterQty

sellItem endp

editMenu proc
    edit_start:
        call clearScreen
        mov dx, offset edit_menu
        call PrintString
        
        mov ah,01h
        int 21h

        sub al,'0'
        cmp al,1
        jne skip1_1
        call edit_item_name_page
        jmp edit_start
    skip1_1:
        cmp al,2
        jne skip1_2
        call edit_item_quantity_page
        jmp edit_start
    skip1_2:
        cmp al,3
        jne skip1_3
        ret
    skip1_3:
        mov dx, offset inputError
        mov ah,09h
        int 21h

        call double_new_line
        call system_pause
        jmp edit_start
editMenu endp

edit_item_name_page proc
    edit_name1:
        call clearScreen
        mov dx, offset en_header
        call PrintString
        call itemList
        call get_name_offset
        cmp bl, 0
        je return1

        mov dx, offset prev_name
        call PrintString

        mov dx, di 
        call PrintString

        mov dx, offset new_name
        call PrintString

        lea dx, temp_name
        mov ah, 0Ah
        int 21h

        cmp [temp_name+2], 'R'
        je return1
        cmp [temp_name+2], 'r'
        je return1

        mov dx, offset input_con
        call PrintString

        mov ah, 01h
        int 21H    
        cmp al, "Y"
        je edit_name2
        cmp al, "y"
        je edit_name2
        cmp al, "N"
        je edit_name1
        cmp al, "n"
        je edit_name1
        jne wrong_input1

    edit_name2:
        ; Replace inv name with temp name
        lea si, temp_name+2             
        mov al, [temp_name+1]           
        xor ah, ah
        mov cx, ax                      
        
        replace_loop:
            mov al, [si]                ; Load byte from temp_name
            mov [di], al                ; Store byte in inv_name
            inc si                     
            inc di                     
            loop replace_loop              ; Repeat for all characters
            
            mov al, [temp_name+1] 
            mov bl, 19                 
            sub bl, al
            xor bh, bh                 
            mov cx, bx
        fill_spaces:
            mov al, ' '                 ; Load space character
            mov [di], al                ; Store space character in inv_name
            inc di                     
            loop fill_spaces           

            mov al, '$'                ; Add dollar sign at the end
            mov [di], al 
            jmp return1                   

    wrong_input1:
        mov dx, offset input_error
        call printString 
        
        call double_new_line
        call system_pause
        jmp edit_name1

    return1:
        ret

edit_item_name_page endp

edit_item_quantity_page proc
    edit_quantity1:
        call clearScreen
        call itemList
        call get_quantity_offset
        cmp bl, 0
        je return3

        mov dx, offset new_quantity
        call PrintString

        lea dx, input_buffer
        mov ah, 0Ah
        int 21h

        cmp [input_buffer+2], 'R'
        je return3
        cmp [input_buffer+2], 'r'
        je return3

        mov dx, offset input_con
        call PrintString

        mov ah, 01h
        int 21H    
        cmp al, "Y"
        je edit_quantity2
        cmp al, "y"
        je edit_quantity2
        cmp al, "N"
        je edit_quantity1
        cmp al, "n"
        je edit_quantity1
        jne wrong_input3
        
    edit_quantity2:


    wrong_input3: 
        mov dx, offset input_error
        call PrintString
        
        call double_new_line
        call system_pause
        jmp edit_quantity1

edit_item_quantity_page endp

get_name_offset proc
    name_offset1:
        ; Prompt user to select an item number
        mov dx, offset prompt_selectNo
        call PrintString

        ; Get input from the user
        lea dx, buffer
        mov ah, 0ah
        int 21h

        ; Check if input starts with 'R' or 'r' 
        cmp byte ptr [buffer+2], 'R'    
        je return4                      
        cmp byte ptr [buffer+2], 'r'    
        je return4                      

        ; Convert input from string to number
        lea si, buffer+2
        xor ax, ax                      ; Clear AX (input number)
        xor bx, bx                      ; Clear BX (not used)
        mov cx, 10                      

        call convert_loop                ; Call conversion routine (assuming it's correct)

        ; Check if the number is within the valid range (1-10)
        cmp ax, 1                        
        jl item_range_error              
        cmp ax, 10                       
        jg item_range_error              

        ; Calculate the correct offset for the item name
        sub ax, 1                        ; 0 = first item
        mov bx, 20                       ; Each item is 20 bytes long
        mul bx                           ; Multiply ax by 20 

        lea di, inv_name                 ; Load the base address of inv_name
        add di, ax                       ; Add calculated offset to SI
        
        ret

    item_range_error:
        ; Print error message for invalid input
        mov dx, offset input_error
        call PrintString

        call double_new_line
        call system_pause
        jmp name_offset1                 

    return4:
        mov bl, 0
        ret                              ; Return if 'R' or 'r' was detected

get_name_offset endp

get_quantity_offset proc
    quantity_offset1:
        mov dx, offset prompt_selectNo
        call PrintString

        ; Get input from the user
        lea dx, buffer
        mov ah, 0ah
        int 21h

        ; Check if input starts with 'R' or 'r' 
        cmp byte ptr [buffer+2], 'R'    
        je return8                      
        cmp byte ptr [buffer+2], 'r'    
        je return8                      

        ; Convert input from string to number
        lea si, buffer+2
        xor ax, ax                      ; Clear AX (input number)
        xor bx, bx                      ; Clear BX (not used)
        mov cx, 10                      

        call convert_loop               ; Call conversion routine (assuming it's correct)

        ; Check if the number is within the valid range (1-10)
        cmp ax, 1                        
        jl item_range_error3             
        cmp ax, 10                       
        jg item_range_error3              

        ; Calculate the correct offset for the item name
        sub ax, 1                        ; 0 = first item
        mov bx, 2                        ; Each item is 20 bytes long
        mul bx                              

        lea di, inv_quantity
        add di, ax
        ret

    item_range_error3:
    ; Print error message for invalid input
        mov dx, offset input_error
        call PrintString

        call double_new_line
        call system_pause
        jmp quantity_offset1                 
    return8:
        mov bl, 0
        ret                              ; Return if 'R' or 'r' was detected
get_quantity_offset endp

calculateTotal proc

    call clearScreen

    call itemList
    mov ah,9
    int 21h
    lea dx,totalPrice
    mov ah,09h
    int 21h

    call getTotalPrice

    xor ax,ax
    mov ax,totalIntPrice
    call printPrice
;
    xor ax,ax
    mov dx,2eh
    mov ah,02h    
    int 21h
;
    mov ax,totalFloatPrice
    call printPrice

    call double_new_line

    call system_pause
    
    jmp menu
calculateTotal endp

convert_loop proc
    mov bl,[si]
    sub bl,'0'
    mul cx  ;mul ax with cx, store at ax
    add ax,bx
    inc si
    cmp byte ptr [si],0Dh
    jne convert_loop
    ret
convert_loop endp

getDateTime proc

    lea dx,currentDate
    call PrintString

    ; Get and print current date
    mov ah, 2Ah  ; get current date
    int 21h
    mov al, dl
    aam
    mov bx, ax
    call DisplayTime

    mov dl, '/' ; print '/'
    mov ah, 02h
    int 21h

    ; Get and print current month
    mov al, dh
    aam
    mov bx, ax
    call DisplayTime

    mov dl, '/' ; print '/'
    mov ah, 02h
    int 21h

    ; Get and print current year
    mov al, ch
    aam
    mov bx, ax
    call DisplayTime

    ; Get and print current time
    mov ah,02h
    mov bh, 0
    mov dh, 16
    mov dl, 32
    int 10h
    lea dx,currentTime
    call PrintString

    ; Get current time
    mov ah, 2Ch
    int 21h

    ; Print hours
    mov al, ch
    aam
    mov bx, ax
    call DisplayTime

    mov dl, ':' ; print ':'
    mov ah, 02h
    int 21h

    ; Print minutes
    mov al, cl
    aam
    mov bx, ax
    call DisplayTime

    mov dl, ':' ; print ':'
    mov ah, 02h
    int 21h

    ; Print seconds
    mov al, dh
    aam
    mov bx, ax
    call DisplayTime

    ;Print Day of Week
    mov ah,2Ah
    int 21h
    mov bx, ax
    xor ah, ah
    mov al, bl
    mov cl, 10
    mul cl
    mov si,ax

    mov ah,02h
    mov bh, 0
    mov dh, 16
    mov dl, 65
    int 10h

    lea dx,currentDayOfWeek
    call PrintString

    lea dx, daysOfWeek[si]
    call PrintString
    ret
getDateTime endp



double_new_line proc
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    mov dx, offset new_line
    int 21h

    ret
double_new_line endp

clear_login_buffer proc 
    clear_buffer:
        mov byte ptr [di], 0         ; Set each byte to 0
        inc di                       ; Move to the next byte
        loop clear_buffer            ; Repeat until CX is 0
    
    ret
clear_login_buffer endp

DisplayTime proc

    mov dl, bh
    add dl,'0'
    mov ah, 02h
    int 21h
    mov dl,bl
    add dl,'0'
    mov ah, 02h
    int 21h

    ret

DisplayTime endp

PrintString proc
    mov ah, 09h        
    int 21h            
    ret
PrintString endp

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

system_pause proc
    mov ah, 09h
    mov dx, offset press_enter
    int 21h
    mov ah, 0ah
    int 21h

    ret
system_pause endp

MoveCursorAscii proc    
    mov ah,02h
    mov bh, 0
    mov dh, 5
    mov dl, 28
    int 10h

    ret
MoveCursorAscii endp

Convertdb proc
    convert_loop1:
    xor dx, dx              ; Clear DX before division (DX:AX is the dividend)
    mov bx, 10              ; Dividing by 10 to extract the least significant digit
    div bx                  ; AX / 10, result in AX (quotient), remainder in DX (remainder is the digit)
    add dl, '0'             ; Convert the remainder to ASCII by adding '0' (48)
    mov [di], dl            ; Store the ASCII character in the buffer
    dec di                  ; Move the pointer to the next position
    test ax, ax             ; Check if the quotient (AX) is 0 (done converting all digits)
    jnz convert_loop1         ; If AX is not zero, continue
    
    
    ret
Convertdb endp

getTotalPrice proc
    mov cx,0
    mov totalIntPrice,0
    mov totalFloatPrice,0
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
    mov priceBuffer,0
    lea di,priceBuffer+5
    mov byte ptr [di],'$'
    dec di

    call Convertdb

    lea dx, [di+1]          
    mov ah, 09h             
    int 21h                 

    ret

printPrice endp


end main