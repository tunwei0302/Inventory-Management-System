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

    invSize equ 200 ; SIZE OF STOCK
        inv_Id DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
        inv_name    DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
             "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
        inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
        inv_price    dd 450, 420, 390, 370, 620, 500, 4550, 1720, 1150, 2200   ;price
    mainMenuOption db 13,10,'Inventory Management System',13,10
               db '===========================',13,10
               db '1. Restock',13,10
               db '2. Sell item',13,10
               db '3. Edit item',13,10
               db '4. Calculate Total',13,10
               db 'Enter your choice > $'
    inputError db 13,10,'Input Invalid! Please try again later.',13,10,'$'
    sellItemMenu db 13,10,'==========================='
                 db 13,10,'        SELLING MENU'
                 db 13,10,'===========================',13,10,'$'
    enterChoice db 13,10,'Enter your choice > $'
    sellItem_jumpTable db ''
    buffer db 20 dup('$')

    input_error db 13, 10, 'Input Error ! Please Try Again !!$'
    press_enter db 13, 10, '+----- Press Enter to Continue -----+$' 
    new_line db 13, 10, '$'
.code
main proc

    mov ax, @data
    mov ds, ax
    
    start:
        ;call printHeader
        call loginpage
        cmp al, 0
        je exit

        call menu
        jmp start
    
    exit:
        mov ah,4ch
        int 21h

main endp

loginpage proc 
    login:
        call clearScreen
        call MoveCursorAscii

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

        mov ah, 09h
        mov dx, offset success_msg       ; Print Successful Login msg
        int 21h
        mov dx, offset new_line
        int 21h
        mov dx, offset new_line
        int 21h

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
        add si, ax
        mov byte ptr [si], '$'           ; Add the '$' to terminate the string

        jmp validate_login

    wrong_input:                         ; Print Input Error Msg for User to Know
        mov ah, 09h 
        mov dx, offset input_error
        int 21h 
        
        mov ah, 09h 
        mov dx, offset new_line
        int 21h
        mov dx, offset new_line
        int 21h
        jmp exit_confirmation

    exit_login:
        mov al,0
        ret
endp

checklogin proc
    cld
    mov cx, 20                ; Set a reasonable maximum length for comparison
    compare_loop:
        mov al, [si]              ; Load byte from str1 into AL
        mov bl, [di]              ; Load byte from str2 into BL
        cmp al, bl                ; Compare the two characters
        jne failed                ; If characters differ, strings are not equal
        test al, al               ; Check if we reached the null terminator (0)
        jz equal                  ; If null terminator, strings matched
        inc si                    ; Move to the next character in str1
        inc di                    ; Move to the next character in str2
        loop compare_loop         ; Continue until CX reaches 0 (unnecessary for fixed length)

    equal:
        mov al, 1
        ret                       ; Return if strings match

    failed:
        ; Print failure message
        mov ah, 09h
        mov dx, offset fail_msg
        int 21h
        mov dx, offset new_line
        int 21h
        mov dx, offset new_line
        int 21h

        call system_pause
        mov al, 0
        ret

endp

menu proc
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
    jmp editItem
skip3:
    cmp al,4
    jne skip4
    jmp calculateTotal
skip4:

    lea dx,[inputError]
    mov ah,09h
    int 21h
    jmp menu



    


    ret
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
    ret
restock endp


sellItem proc
    call clearScreen

    lea dx,[sellItemMenu]
    mov ah,09h
    int 21h
    
    mov cx,10
    mov si,0
itemList:

    mov bx,si
    inc bx
    ;add bx,'0'

    cmp bx,9
    jle singleDigit
    mov dx,'1'
    mov ah,02h
    int 21h

    
    ;mov si,0
    ;mov dx,si
    ;add dx,'0'
    ;mov ah,02h
    ;int 21h
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

    mov dx,13
    mov ah,02h
    int 21h
    mov dx,10
    mov ah,02h
    int 21h

    inc si
    loop itemlist


    lea dx,enterChoice
    mov ah,09h
    int 21h

    lea dx,buffer
    mov ah,0ah
    int 21h


    lea si,buffer+2
    xor ax,ax
    mov cx,10
    xor bx,bx

convert_loop:
    mov bl,[si]
    sub bl,'0'
    mul cx  ;mul ax with cx, store at ax
    add ax,bx
    inc si
    cmp byte ptr [si],0Dh
    jne convert_loop

    sub ax,1

    mov bx,2
    lea si,inv_quantity
    mul bx
    add si,ax
    mov dx,[si]
    



    ;xor bx,bx
    ;mov bx,20 
    ;mul bx
;
    ;lea si,inv_name
    ;add si,AX




    ;lea si,inv_name
    ;add si,ax 
    ;lea dx,[si] 

    ;mov  ah,09h 
    ;int 21h




    
    ;sub al,'0'
    ;dec al
;
    ;mov dx,ax
;
    ;mov ah,02h
    ;int 21h
    ;xor ah,ah
    ;xor bx,bx
    ;mov bl,20
    ;mul bl
;
;
;
    ;lea si,inv_name
    ;add si,ax
    ;
    ;lea dx,[si]
    ;mov ah,09h
    ;int 21h

    ret
sellItem endp


editItem proc
    ret
editItem endp

calculateTotal proc
    ret
calculateTotal endp

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




























clear_login_buffer proc 
    clear_buffer:
        mov byte ptr [di], 0         ; Set each byte to 0
        inc di                       ; Move to the next byte
        loop clear_buffer            ; Repeat until CX is 0
    
    ret
endp

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
endp

MoveCursorAscii proc    
    mov ah,02h
    mov bh, 0
    mov dh, 5
    mov dl, 28
    int 10h

    ret
MoveCursorAscii endp

end main