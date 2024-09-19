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
    invSize equ 200 ; SIZE OF STOCK
        inv_Id DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
        inv_name    DB "PENCIL             $", "ERASER             $", "RULER              $", "CORRECTION TAPE    $", "MARKER PEN         $",\
             "SCISSORS           $", "NOTEBOOK           $", "MARKER             $", "PAPERCLIPS         $", "STAPLER            $"   ;item name
        inv_quantity    DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
        inv_price    dd 4.5, 4.2, 3.9, 3.7, 6.2, 5.0, 45.5, 17.2, 11.5, 22.0    ;price
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
.code
main proc

    mov ax, @data
    mov ds, ax
    
    ;call printHeader
    call clearScreen
    call menu
    
    
    
    mov ah,4ch
    int 21h

main endp

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
    xor bx,bx
    mov bx,20 
    mul bx

    lea si,inv_name
    add si,ax 
    lea dx,[si] 

    mov  ah,09h 
    int 21h




    
    ;sub al,'0'
    dec al

    mov dx,ax

    mov ah,02h
    int 21h
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

MoveCursorAscii proc    
    mov ah,02h
    mov bh, 0
    mov dh, 5
    mov dl, 28
    int 10h

    ret
MoveCursorAscii endp

end main