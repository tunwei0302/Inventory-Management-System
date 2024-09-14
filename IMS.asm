.model small
.stack 100h
.data

    ; SIZE OF STOCK
    invSize equ 100
        inv DW 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
            DB "PEPSI     ", "SPRITE    ", "COKE      ", "CHIPS     ", "MILK      ", "CHOCOLATE ", "BISCUIT   ", "CAKE      ", "MAGGIE    ", "BREAD     " 
            DW 20, 1, 15, 2, 13, 2, 18, 0, 1, 0, 4, 4, 3, 3, 6, 5, 45, 17, 11, 22, '$'

    ; Define offsets for various properties of each inventory item
    inv_id_offset DW 0          ; Offset for the item ID (2 bytes)
    inv_name_offset DW 20       ; Offset for the item name (2 bytes)
    inv_quantity_offset DW 120  ; Offset for the item quantity (2 bytes)
    inv_price_offset DW 140     ; Offset for the item price (2 bytes)

    salesNum DW 0, 6, 10, 0, 2, 5, 0, 30, 0, 7,'$'
    priceItem DW 6, 6, 6, 10, 11, 8, 53, 20, 16, 19, '$'
    totalSales DW ? ; ? = uninitialized value and not specified at that point

    ; Initialize variables for user input
    itemID DW ?
    itemAmount DW ?

    ; MAIN MENU
    menuHeader    db 13, 10, '-------- INVENTORY MANAGEMENT SYSTEM --------$'
    menuOption    db 10, 10, '1. View Inventory'
                  db 13, 10, '2. Restock Item'
                  db 13, 10, '3. Sell Item'
                  db 13, 10, '4. Sort Item'
                  db 13, 10, '5. Sales Report'
                  db 13, 10, '6. Exit', 13, 10, '$'
    Choice        db 13, 10, 'Enter your choice: ', 13, 10, '$'
    
    ; VIEW INVENTORY MENU
    invHeader     db 13, 10, '-------------------- INVENTORY LIST --------------------$'
    ; DISPLAY LIST OF ITEM
    itemHeader    db 13, 10, 'ItemID'
                  db 9, 'Name'
                  db 9, 9, 'Quantity'
                  db 32, 32, 9, 'Price(RM)$'
    alertMsg      db 13, 10, 'WARNING!!! Items OUT of stock are highlighted in RED!!!'
                  db 13, 10, 'WARNING!!! Items LOW on stock are highlighted in YELLOW!!!$'
    invOption     db 13, 10, '1. Restock Items'
                  db 13, 10, '2. Sell Items'
                  db 13, 10, '3. Back to Main Menu', 13, 10, '$'
                  
    ; RESTOCK ITEM MENU
    resHeader     db 13, 10, '--------------------- RESTOCK ITEM ---------------------$'
    resSelect     db 13, 10, 'Select an item ID to restock: $'
    resAmount     db 13, 10, 'PLEASE enter the amount to sell (between 1-9): $'
    resMsgS       db 13, 10, 'The item has been SUCCESSFULLY replenished!!!$'
    resMsgF       db 13, 10, 'The item has been FAIL to replenished!!!$'
    
    ;  SELL ITEM MENU
    sHeader       db 13, 10, '---------------------- SELL ITEM ------------------------$'
    sSelect       db 13, 10, 'Enter the item ID to sell: $'
    sAmount       db 13, 10, 'PLEASE enter the amount to sell (between 1-9): $'
    sMsgS         db 13, 10, 'Item has been SOLD successfully!!!$'
    sMsgF         db 13, 10, 'Item CANNOT be sell, not enough quantity, please restock!!!$'
    
    ;  SORT ITEM
    sortHeader    db 13, 10, '---------------------- SORT ITEM -----------------------$'
    sortOption    db 13, 10, '1. Low/Out Of Stock'
                  db 13, 10, '2. In Stock'
                  db 13, 10, '3. Back to Main Menu', 13, 10, '$'
    sortNote      db 13, 10, '*** Items are sort by the Inventory Quantity ***', 13, 10, '$'
    
    ;  SALES REPORT
    repHeader     db 13, 10, '----------------------------- SALES REPORT -----------------------------$'
    saleHeader    db 13, 10, 'ItemID'
                  db 9, 32, 32, 'Name'
                  db 9, 9, 'Quantity Sold'
                  db 32, 32, 32,'Price/Unit'
                  db 9, 'Total Earned$'
    Sales         db 13, 10, 'Total Sales (RM): $' 
    repOption     db 13, 10, '1. Back to Main Menu'
                  db 13, 10, '2. Exit the Program$'
    
    ; COMMON USED  
    nextLine      db 13, 10, '$'              
    invalidInput  db 13,10, 'Invalid input!!! Please try again.', 13, 10, '$'
                  
    ; EXIT
    exitMsg       db 13, 10, 'Exiting.....', 13, 10, '$'

.code

    ; Macrointrustions

    ; Macro for inputting a readabable input from standard input
    userInput macro 
        MOV AH, 01h       ; Read Input
        INT 21h           ; Interrupt
        endm

    userInputId macro
        MOV AH, 01
        INT 21H
        endm

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

    inputID macro
        ; Convert ASCII to integer
        SUB AL, 30h 
        ADD AL, AL
        ; Subtract 136 to get the offset
        SUB AX, 136
        ; Store the item ID in ITEM_ID variable
        MOV itemID, AX 
        endm

    inputQuantity macro
        ; Read the user's input for quantity
        SUB AL, 30H
        SUB AX, 256
        MOV CX, AX
        endm   

    sortedHeader macro
        CALL clearScreen
        MOV AH, 09H
        MOV DX, OFFSET sortHeader
        INT 21H
        LEA DX, itemHeader
        MOV AH, 09H
        INT 21H
        CALL printNextLine
        MOV BP, 0
        LEA SI, inv
        endm
    
    sortFilter macro
            MOV AX, [SI]
            CALL printInt           ; Print integer
            CALL printTab

            MOV DX, OFFSET inv + 20 ; Load inv name into DX
            ADD DX, BP              ; Add BP to DX to point to next word
            CALL printString        ; Print string
            MOV AX, [SI + 120]      ; Load inv stock into AX
            CALL checkInt           ; Check if stock is less than 3
            CALL printTab
        
            MOV AX, [SI + 120] 
            CALL printInt
            CALL printTab
            CALL printTab
        
            MOV AX, [SI + 140]
            CALL printInt
            CALL printNewLine
            endm

MAIN PROC               
    MOV AX, @data   ; Set data segment
    MOV DS, AX      ; Set data segment register

    ; --------------------------------------------------- DISPLAY INTERFACE GUI ---------------------------------------------------
    mainMenu:
        CALL clearScreen
        CALL displayMenu 
        CALL mainNavigate
        RET

    invPage:
        CALL clearScreen
        ;CALL displayInv
        CALL viewInv
        CALL invNavigate
        RET

    resPage:
        CALL clearScreen
        CALL displayRestock
        CALL viewInv
        CALL restockInv
        RET

    sellPage:
        CALL clearScreen
        CALL displaySell
        CALL viewInv
        CALL sellInv
        RET

    sortPage:
        CALL clearScreen
        CALL displaySort
        CALL viewInv
        CALL sortNavigate
        CALL invNavigate
        RET

    reportPage:
        CALL clearScreen
        CALL displayReport
        CALL viewReport
        CALL reportNavigate
        RET

    exitPage:
        CALL clearScreen
        CALL displayExit   
        RET
        
    ; ------------------------------------------------------ OPTION NAVIGATE ------------------------------------------------------
    
    ; Navigate the user in main menu
    mainNavigate: 
        userInput AL
        
        ; Check User Input
        CMP AL, '1'         ; Compare the character in AL with '1'
        JNE checkOption2    ; If not equal to '1', jump to check_option_2_IN  
        JE invPage          ; If equal to '1', jump to MAIN (presumably to handle option 1)
        
        checkOption2:
            CMP AL, '2'
            JNE checkOption3
            JMP resPage

        checkOption3:
            CMP AL, '3'
            JNE checkOption4
            JMP sellPage

        checkOption4:
            CMP AL, '4'
            JNE checkOption5
            JMP sortPage

        checkOption5:
            CMP AL, '5'
            JNE checkOption6
            JMP reportPage

        checkOption6:
            CMP AL, '6'
            JNE notValidInput
            JMP exitPage 

        ; Handle invalid input
        notValidInput:
            LEA DX, invalidInput 
            MOV AH, 09H
            INT 21H
            JMP  mainMenu
            RET
        RET

    invNavigate:
        ; Display inventory options
        LEA DX, invOption
        MOV AH, 09H
        INT 21h

        MOV AH, 09H
        MOV DX, offset Choice
        INT 21H        
        
        userInput AL
        
        ; Check User Input
        CMP AL, '1'          
        JNE invCheckOption2  
        JMP resPage          
        
        invCheckOption2:
            CMP AL, '2'
            JNE invCheckOption3
            JMP sellPage

        invCheckOption3:
            CMP AL, '3'             
            JNE invNotValidInput   
            JMP mainMenu 

        ; Handle invalid input
        invNotValidInput:
            LEA DX, invalidInput 
            MOV AH, 09H
            INT 21H
            JMP invPage
            RET
        RET      

    sortNavigate:
        ; Display sort message
        LEA DX, sortNote
        MOV AH, 09H
        INT 21H

        LEA DX, sortOption
        MOV AH, 09H
        INT 21H

        MOV AH, 09H
        MOV DX, OFFSET Choice
        INT 21H
    
        userInput AL
    
        ; Check User Input
        CMP AL, '1'
        JNE sortCheckOption2
        JMP lowStock
    
        sortCheckOption2:
            CMP AL, '2'
            JNE sortCheckOption3
            JMP availableStock
        
        sortCheckOption3:
            CMP AL, '3'
            JNE sortNotValidInput
            JMP mainMenu
       
        ; Handle invalid input
        sortNotValidInput:
            LEA DX, invalidInput 
            MOV AH, 09H
            INT 21H
            CALL printNextLine
            JMP sortNavigate
        RET      

    reportNavigate:
        LEA DX, repOption 
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
        JMP mainMenu

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

    ; ------------------------------------------------------- DISPLAY PAGE -------------------------------------------------------
    
    ; DISPLAY MENU PAGE
    displayMenu:
        ; Display main menu header
        MOV AH, 09h
        MOV DX, OFFSET menuHeader
        INT 21h
        ; Display menu options
        MOV AH, 09h
        MOV DX, OFFSET menuOption
        INT 21h  
        ; Display menu choice
        MOV AH, 09H
        MOV DX, OFFSET Choice
        INT 21h  
        RET ; Return back

    ; DISPLAY VIEW INVENTORY PAGE    
    displayInv:
        ; Display inventory header
        MOV AH, 09H
        MOV DX, OFFSET invHeader
        INT 21h
        ; Display item list header
        MOV AH, 09H
        MOV DX, OFFSET itemHeader
        INT 21h
        RET

    ; DISPLAY RESTOCK INVENTORY PAGE 
    displayRestock:
        ; Display restock header
        MOV AH, 09H
        MOV DX, OFFSET resHeader
        INT 21h
        CALL printNewLine
        RET 
        
    ; DISPLAY SELL ITEM PAGE   
    displaySell:
        ; Display sell header
        MOV AH, 09H
        MOV DX, OFFSET sHeader 
        INT 21h
        CALL printNewLine
        RET  

    ; DISPLAY SORT ITEM TABLE PAGE
    displaySort:
        ; Display sort header
        LEA DX, sortHeader 
        MOV AH, 09H
        INT 21h
        CALL printNextLine
        RET

    ; DISPLAY SALES REPORT
    displayReport:
        ; Display sale report header
        MOV AH, 09H
        MOV DX, OFFSET repHeader 
        INT 21h
        
        ; Display column header
        LEA DX, saleHeader
        MOV AH, 09H
        INT 21H
        RET

    ; EXIT PROGRAM
    displayExit:
        ; Display exit message
        MOV AH, 09H
        LEA DX, exitMsg
        INT 21H
        ; Terminate the program
        CALL exit
        RET

    ; ------------------------------------------------------ INVENTORY TABLE ------------------------------------------------------
    
    viewInv:
        CALL displayInv
        CALL printNewLine
        MOV BP, 0
        LEA SI, inv

        loopView:
            MOV AX, [SI]
            CMP AX, 10
            JA endInv
            
            CALL printInt
            CALL printTab

            MOV DX, offset inv + 20
            ADD DX, BP
            CALL printString
            CALL printTab
           
            MOV AX, [SI + 120]
            CALL checkInt
            MOV AX, [SI + 120]
            CALL printInt
            
            CALL printTab
            CALL printTab
           
            MOV AX, [SI + 140]
            CALL printInt
            CALL printNewLine
           
            Addition al
            JMP loopView

        endInv:
            LEA DX, alertMsg
            MOV AH, 09H
            INT 21H
            CALL printNewLine
            RET
        RET

    ; RESTOCK INVENTORY
    restockInv: 
        CALL printNextLine
            
        ; Prompt user to select an item ID to restock
        LEA DX, resSelect
        MOV AH, 09h
        INT 21h 

        ; Read the user's choice
        userInputId al

        ; Convert ASCII to integer
        inputID al

        ; Prompt user to enter the amount to restock
        LEA DX, resAmount
        MOV AH, 09h 
        INT 21h

        ; Read the user's input for restock amount
        userInputId al

        ; Convert ASCII to integer
        inputQuantity al

        ; Calculate the memory location of the selected item in the inventory
        LEA SI, inv
        ADD SI, itemID
        ; Add the restock amount to the current quantity
        ADD CX, [SI]
        ; Update the quantity in inventory
        MOV [SI], CX 
        
        CALL clearScreen
        CALL printNewLine

        ; Display restock status message
        LEA DX, resMsgS
        CALL printNewLine
        MOV AH, 09h 
        INT 21h 
        CALL printNewLine

        ; View updated inventory and navigate
        CALL viewInv
        CALL invNavigate
        RET
        
    ; SELL INVENTORY
    sellInv:
        ; Select Item ID to sell
        LEA DX, sSelect
        MOV AH, 09H
        INT 21H 

        ; Read the user's input
        userInputId al

        ; Convert ASCII to integer
        inputID al

        ; Prompt user to enter the quantity to sell
        LEA DX, sAmount
        MOV AH, 09H 
        INT 21H

        ; Read the user's input for quantity
        userInputId al
        inputQuantity al

        ; Calculate the memory location of the selected item in the inventory
        LEA SI, inv
        ADD SI, itemID
        MOV BX, [SI]    ; Load current stock into BX
        SUB BX, CX      ; Subtract sold quantity from stock
        CMP BX, 0       ; Check if stock is negative
        JS reset
        
        ; Update stock quantity
        MOV WORD PTR [SI], BX
        JMP soldItem

    viewReport:
        CALL printNewLine
        
        ; Set base pointer to zero
        MOV BP, 0
        ; Initialize source index, BX, and destination index, DI
        LEA SI, inv                 ; Get address of inventory data into SI
        MOV BX, offset salesNum     ; Get address of sales numbers
        MOV DI, offset priceItem    ; Get address of item selling prices

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
            MOV AX, [BX]            ; Load sales number
            CALL printInt           ; Print sales number
            CALL printTab
            CALL printTab

            ; Unit price
            MOV AX, [BX + 22]       ; Load unit price
            CALL printInt           ; Print unit price
            CALL printTab
            CALL printTab

            ; Calculate total earnings for the item
            MOV CX, [BX]            ; Load sales number
            MOV AX, [DI]            ; Load unit price
            MUL CX                  ; Multiply to get total earnings for the item

            ; Add earnings to the total sales
            ADD [totalSales], AX
            CALL printInt           ; Print total earnings for the item
            CALL printNextLine
            ; Increment pointers for next iteration
            Addition al
            ADD BX, 2
            ADD DI, 2
            JMP loopReport

        doneReport:
            LEA DX, Sales           ; Load address of the total sales label string
            MOV AH, 09h             ; Display string function
            INT 21h                 ; Display the total sales label string
            MOV AX, [totalSales]    ; Move total earnings to AX register
            CALL printInt           ; Print total earnings
            CALL printNextLine
            RET 
        RET
    
    ; --------------------------------------------------------- FUNCTION ---------------------------------------------------------
    
    reset: 
        ; Reset stock quantity to original
        MOV BX, [SI]
        MOV WORD PTR [SI], BX
        ; Display message for insufficient stock
        CALL clearScreen
        CALL printNewLine
        LEA DX, sMsgF
        MOV AH, 09H 
        INT 21H 
        CALL printNewLine
        CALL viewInv
        CALL invNavigate
        RET 

    soldItem:
        ; Update complete sale
        CALL saleComplete
        ; Display message for successful sales
        CALL clearScreen
        CALL printNewLine
        LEA DX, sMsgS
        MOV AH, 09H 
        INT 21H 
        CALL printNewLine
        CALL viewInv
        CALL invNavigate
        RET
        
    saleComplete: 
        ; Adjust item ID for sales report
        MOV AX, itemID 
        SUB AX, 120 
        MOV itemID, AX
        ; Update sales report
        LEA SI, salesNum 
        ADD SI, itemID
        MOV AX, [SI]
        ADD CX, AX 
        MOV WORD PTR [SI], CX
        RET

    availableStock:
        sortedHeader al

        loopAvailable:
            MOV AX, [SI] 
            CMP AX, 10 
            JA endAvailable

            MOV AX, [SI + 120]      ; Load inv ID AX
            CMP AX, 6               ; Check if end of array
            JL stockDone 

            sortFilter al

            Addition al
            JMP loopAvailable

        stockDone:
            Addition al
            JMP loopAvailable
            RET 

        endAvailable:
            RET
        RET

    lowStock:
        sortedHeader al

        loopLow:
            MOV AX, [SI]        ; Move the word at the memory address pointed to by SI into the AX register
            CMP AX, 10 
            JA endLow           ; Jump to endLow if the value in AX is above (greater than) 10

            MOV AX, [SI + 120]  ; Load inv ID into AX
            CMP AX, 6           ; Check if end of array
            JG lowStockDone     ; Jump to label lowStockDone if the value in AX is greater than 3

            sortFilter al

            Addition al           
            JMP loopLow 

        lowStockDone:
            Addition al
            JMP loopLow
            RET 

        endLow:
            CALL printNextLine
            ; Display column headers
            LEA DX, alertMsg
            MOV AH, 09H
            INT 21H
            CALL printNewLine
            RET
        RET 

    ; ------------------------------------------------------- ITEM QUANTITY -------------------------------------------------------
    
    ; PRINT INTEGER DATA TYPE
    printInt:
        ; Convert word to string
        PUSH BX           ; Save current value by BX on the stack
        MOV BX, 10        ; Divisor: set BX to 10
        XOR CX, CX        ; Counter: Clear CX for digit count

        ; CONVERT WORD TO STRING
        convertLoop:
            XOR DX, DX            ; Clear the high byte of DX
            DIV BX                ; Divide AX by BX
            ADD DL, '0'           ; Convert the remainder to ASCII and 
            PUSH DX               ; Push it onto the stack
            INC CX                ; Increment the digit counter
            CMP AX, 0             ; Check if AX is zero (end of conversion)
            JNE convertLoop       ; Repeat loop if not zero

        loopInt:
            POP DX                ; Pop the next digit from the stack and print it
            MOV AH, 02            ; Write the character to the output
            INT 21h               
            DEC CX                ; Decrement the digit counter
            CMP CX, 0             ; Check if all digits have been printed
            JNE loopInt           ; Repeat loop if not all digits printed
            POP BX                ; Restore BX from the stack and return
            RET
    
    checkInt:
        ; Check if the value in AX is less than 3
        CMP AX, 3
        JGE GREATER_THAN_OR_EQUAL_TO_3  ; Jump to the label greater_or_equal if AX is greater than or equal to BX
        
        ; Check if the value in AX is equal to zero
        CMP AX, 0
        JNZ notZero
        CALL printRed                   ; Print in red color if zero
        RET

        CALL printYellow                ; Print in yellow color if less than 3 and not zero
        RET

        GREATER_THAN_OR_EQUAL_TO_3:
            ; Handle cases where the value is greater than or equal to 3 if needed
            RET

        notZero:
            ; If the value is not zero, print yellow color
            CALL printYellow
            RET

    ; PRINT RED COLOR CHARACTER STRING
    printRed:
        ; Input: CX = length of string, DX = offset of string
        printColor al

        ; Loop until print
        loopRed:
            MOV DL, [BX]  ; Load character from memory
            MOV AH, 09h
            MOV AL, DL    ; Load character into AL
            MOV BL, 04h   ; Set background color to black with blink
            OR BL, 80h    ; Set bit 7 for red color
            INT 10h       ; BIOS interrupt to print the character
            INC BX        ; Increment offset to next character
            LOOP loopRed  ; Repeat until 10 characters are printed

        ; Done Looping
        doneRed:
            doneColor al
            RET

    ; PRINT YELLOW COLOR CHARACTER STRING
    printYellow:
        ; Input: CX = length of string, DX = offset of string
        printColor al

        ; Loop until print
        loopYellow:
            MOV DL, [BX]    ; Load character from memory
            MOV AH, 09h     
            MOV AL, DL      ; Load character into AL
            MOV BL, 0Eh     ; Set background color to black, foreground color to yellow (0Eh)
            INT 10h         ; BIOS interrupt to print the character
            INC BX          ; Increment offset to next character
            LOOP loopYellow ; Repeat until 10 characters are printed
            
        ; Done looping
        doneYellow:
            doneColor al
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

    ; ------------------------------------------------------- PAGE SETTING -------------------------------------------------------
    
    ; CLEAR PREVIOUS PAGE
    clearScreen:
        MOV AX, 0600h    ; AH = 06h (Function 06h of INT 10h), AL = 0 (Clear entire window)
        mov al, 0        ; Amount of lines to navigate
        MOV BH, 07h      ; BH = 07h (Attribute - white on black)
        MOV CX, 0        ; CX = 0 (Upper left corner - row = 0, column = 0)
        MOV DX, 184Fh    ; DX = 184Fh (Lower right corner - row = 24, column = 79)
        INT 10h          ; Call BIOS interrupt to scroll the window
        RET              ; Return
    
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

    ; EXIT
    exit:
        MOV AH, 4Ch
        INT 21h
    
MAIN ENDP
END MAIN