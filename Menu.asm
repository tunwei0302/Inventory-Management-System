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
    ascii_Buffer db 26
    invSize db 200 ; SIZE OF STOCK
        inv DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
            DB "PENCIL              ", "ERASER              ", "RULER               ", "CORRECTION TAPE     ", "MARKER PEN          ",\
             "SCISSORS            ", "NOTEBOOK            ", "MARKER              ", "PAPERCLIPS          ", "STAPLER             "   ;item name
            DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
            dd 4.5, 4.2, 3.9, 3.7, 6.2, 5.0, 45.5, 17.2, 11.5, 22.0, '$'    ;price

            
    ;year db ?
    ;month db ?
    ;day db ?
    ;hour db ?
    ;minute db ?
    ;second db ?

.code
main proc

    mov ax, @data
    mov ds, ax

    call printHeader

    mov ah,4ch
    int 21h

main endp

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

getDateTime proc

    lea dx,currentDate
    call PrintString

    ; Get and print current date
    mov ah, 2Ah  ; get current date
    int 21h
    mov al, dl
    aam
    mov bx, ax
    call Disp

    mov dl, '/' ; print '/'
    mov ah, 02h
    int 21h

    ; Get and print current month
    mov al, dh
    aam
    mov bx, ax
    call Disp

    mov dl, '/' ; print '/'
    mov ah, 02h
    int 21h

    ; Get and print current year
    mov al, ch
    aam
    mov bx, ax
    call Disp

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
    call Disp

    mov dl, ':' ; print ':'
    mov ah, 02h
    int 21h

    ; Print minutes
    mov al, cl
    aam
    mov bx, ax
    call Disp

    mov dl, ':' ; print ':'
    mov ah, 02h
    int 21h

    ; Print seconds
    mov al, dh
    aam
    mov bx, ax
    call Disp

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

Disp proc

    mov dl, bh
    add dl,'0'
    mov ah, 02h
    int 21h
    mov dl,bl
    add dl,'0'
    mov ah, 02h
    int 21h

    ret

Disp endp

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