.model small

.stack

.data

invSize db 200 ; SIZE OF STOCK
        inv DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ;item id
            DB "PENCIL              ", "ERASER              ", "RULER               ", "CORRECTION TAPE     ", "MARKER PEN          ",\
             "SCISSORS            ", "NOTEBOOK            ", "MARKER              ", "PAPERCLIPS          ", "STAPLER             "   ;item name
            DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0 ;quantity
            dd 4.5, 4.2, 3.9, 3.7, 6.2, 5.0, 45.5, 17.2, 11.5, 22.0, '$'    ;price

;  TOTAL INVENTORY VALUE
    repHeader       db 13, 10, '------------------- Total Inventory Value -------------------$'
    invValueHeader  db 13, 10, 'ItemID'
                    db 9, 32, 32, 'Name'
                    db 9, 9, 'Quantity'
                    db 32, 32, 32,'Unit Price'
                    db 9, 'Total Price$'
    invValue        db 13, 10, 'Total Value (RM): $' 
    invValueOption  db 13, 10, '1. Back to Main Menu'
                    db 13, 10, '2. Exit the Program$'

    Choice        db 13, 10, 'Enter your choice: ', 13, 10, '$'
    nextLine      db 13, 10, '$'     
    invalidInput  db 13,10, 'Invalid input!!! Please try again.', 13, 10, '$'
    ; EXIT
    exitMsg       db 13, 10, 'Exiting.....', 13, 10, '$'

    totalPrice DW ? ; ? = uninitialized value and not specified at that point

.code
    Addition macro
        ADD BP, 10
        ADD SI, 2   ; Increment SI to point to next word
        endm

    printColor macro
        PUSH AX     ; Preserve registers
        PUSH BX
        PUSH CX
        MOV BX, DX  ; Set BX to the offset of the string
        MOV CX, 10  ; Initialize counter for character length
        endm

    doneColor macro
        POP CX      ; Restore registers
        POP BX
        POP AX
        endm

MAIN PROC
    MOV AX, @data   ; Set data segment
    MOV DS, AX      ; Set data segment register

    invPage:
        CALL displayReport
        CALL viewReport
        CALL reportNavigate
        RET

    exitPage:
        CALL displayExit   
        RET

    reportNavigate:
        LEA DX, invValueOption 
        MOV AH, 09h 
        INT 21h  

        CALL printNextLine
        LEA DX, Choice
        MOV AH, 09H
        INT 21H

        ; Read a single character from standard input
        MOV AH, 01H
        INT 21h
        CMP AL, '1'
        JNE reportCheckOption1
        JMP displayReport

        reportCheckOption1:
            CMP AL, '2'
            JNE reportNotValidInput
            JMP exitPage 

        reportNotValidInput:
            ; Handle invalid input
            LEA DX, invalidInput 
            MOV AH, 09H
            INT 21H
            JMP  reportNavigate
        RET

    displayReport:
        ; Display sale report header
        MOV AH, 09H
        MOV DX, OFFSET repHeader 
        INT 21h
        
        ; Display column header
        LEA DX, invValueHeader
        MOV AH, 09H
        INT 21H
        RET

    displayExit:
        ; Display exit message
        MOV AH, 09H
        LEA DX, exitMsg
        INT 21H
        ; Terminate the program
        CALL exit
        RET

    viewReport:
        CALL printNewLine
        
        ; Set base pointer to zero
        MOV BP, 0
        ; Initialize source index, BX, and destination index, DI
        LEA SI, inv                 ; Get address of inventory data into SI
        MOV BX, SI

        loopReport:                 ; Begin loop to see sales report
            MOV AX, [SI]            ; Load item ID from inventory
            CMP AX, 10              ; Check if end of inventory is reached
            JA doneReport           ; End loop if end store 

            CALL printInt           ; Print item ID
            CALL printTab   
            CALL printSpace  
            CALL printSpace       
            
            ; Print item name
            MOV DX, offset inv + 20
            ADD DX, BP              ; Add base pointer to point to the next item name
            CALL printString        ; Print the ITEM name
            CALL printTab

            ; Sales Number
            MOV AX, [BX + 220]            ; Load sales number
            CALL printInt           ; Print sales number
            CALL printTab
            CALL printTab

            ; Unit price
            MOV AX, [BX + 240]       ; Load unit price
            CALL printInt           ; Print unit price
            CALL printTab
            CALL printTab

            ; Calculate total earnings for the item
            MOV CX, [BX + 220]            ; Load quantity
            MOV AX, [BX + 240]            ; Load unit price
            MUL CX                  ; Multiply to get total price for the item

            ; Add earnings to the total sales
            ADD [totalPrice], AX
            CALL printInt           ; Print total price for the item
            CALL printNextLine
            ; Increment pointers for next iteration
            
            Addition al
            ADD BX, 2
            ADD DI, 2
            JMP loopReport

        doneReport:
            LEA DX, invValue           ; Load address of the total sales label string
            MOV AH, 09h             ; Display string function
            INT 21h                 ; Display the total sales label string
            MOV AX, [totalPrice]    ; Move total earnings to AX register
            CALL printInt           ; Print total price
            CALL printNextLine
            RET 
        RET

    ; PRINT CHARACTERS STRING
    printString:
        ; Input: CX = length of string, DX = offset of string
        printColor al

        ; Loop until print
        loopString:
            MOV DL, [BX]      ; Load character from memory
            INT 21H           ; Output the character
            INC BX            ; Move to the next character
            LOOP loopString   ; Repeat until the end of string is reached

        ; Done looping
        done:
            doneColor al
            RET 

    ; TAB
    printTab:
        MOV DL, 09
        MOV AH, 02
        INT 21H
        RET

    ; NEW LINE
    printNewLine:
        MOV DL, 0ah
        MOV AH, 02
        INT 21h
        RET

    ; NEXT LINE
    printNextLine:
        MOV AH, 09H
        MOV DX, offset nextLine
        INT 21h
        RET

    ; SPACE    
    printSpace:
        MOV DL, 32
        MOV AH, 02
        INT 21H
        RET 

    ; PRINT INTEGER DATA TYPE
    printInt:
        ; Convert word to string
        PUSH BX           ; Save current value by BX on the stack
        MOV BX, 10        ; Divisor: set BX to 10
        XOR CX, CX        ; Counter: Clear CX for digit count

    exit:
        MOV AH, 4Ch
        INT 21h
    
MAIN ENDP
END MAIN