.model small

.stack

.data
    asciiArt1 db '                             _',13,10,\
                 '                           _|=|__________',13,10,\
                 '                          /              \',13,10,\
                 '                         /                \',13,10,\
                 '                        /__________________\',13,10,\
                 '                         ||  || /--\ ||  ||',13,10,\
                 '                         ||[]|| | .| ||[]||',13,10,\
                 '                       ()||__||_|__|_||__||()',13,10,\
                 '                      ( )|-|-|-|====|-|-|-|( ) ',13,10,\
                 '                      ^^^^^^^^^^====^^^^^^^^^^^',13,10,'$'
    menuHead db 'Sinaran Inventory Management System',13,10,'$'
    currentDate db 'Date: $'
    currentTime db 'Time: $'
    currentDayOfWeek db 'Day: $'
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
    mov cx,11

header:
    lea dx,asciiArt1
    call PrintString

    mov ah,02h
    mov dl, 30
    int 10h
    lea dx,menuHead
    call PrintString
    
    call getDateTime

    ret


printHeader endp

getDateTime proc

lea dx,currentDate
call PrintString

currentDay:
    
    mov ah,2ah  ;get current date
    int 21h
    mov al, dl
    aam
    mov bx, ax
    call Disp

    mov dl, '/' ;print '/' between date
    mov ah,02h
    int 21h
currentMonth:

    mov ah,2ah  ;get current date
    int 21h
    mov al, dh
    aam
    mov bx, ax
    call Disp

    mov dl, '/' ;print '/' between date
    mov ah,02h
    int 21h

currentYear:
    
    mov ah,2ah  ;get current date
    int 21h
    not cx
    inc cx
    mov ax,cx
    aam
    mov bx, ax
    call Disp


currentHour:
    mov ah,2ch  ;get current time
    int 21h
    mov al,ch
    aam
    mov bx,ax
    call Disp

    mov dl, ':' ;print ':' between time
    mov ah,02h
    int 21h

currentMinute:
    mov ah,2ch  ;get current time
    int 21h
    mov al,cl
    aam
    mov bx,ax
    call Disp

    mov dl, ':' ;print ':' between time
    mov ah,02h
    int 21h

currentSecond:
    mov ah,2ch  ;get current time
    int 21h
    mov al,dh
    aam
    mov bx,ax
    call Disp


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

MoveCursorMiddle proc    
    mov ah,02h
    mov bh, 0
    mov dh, 12
    mov dl, 30
    int 10h

    ret
MoveCursorMiddle endp

end main