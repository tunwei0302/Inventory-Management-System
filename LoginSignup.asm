.MODEL SMALL
.STACK 100H

.DATA
    username_prompt db "Enter Username: $"
    password_prompt db "Enter Password: $"
    login_success db "Login Successful!$"
    login_fail db "Login Failed! Try Again.$"
    signup_success db "Signup Successful!$"
    user_exists db "User already exists!$"
    newline db 0Dh, 0Ah, "$"

    ; Storage for 10 users and their passwords (20 characters max each)
    users db 10 dup(20 dup('$'))
    passwords db 10 dup(20 dup('$'))

    current_user db 20 dup('$')
    current_password db 20 dup('$')

.CODE
MAIN:
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display the menu and get user's choice
    CALL DISPLAY_MENU
    CMP AL, '1'
    JE SIGNUP
    CMP AL, '2'
    JE LOGIN
    JMP EXIT

SIGNUP:
    ; Get username and password, then store them
    CALL INPUT_USERNAME
    CALL CHECK_USER_EXISTS
    CMP AL, 1
    JE USER_ALREADY_EXISTS
    CALL INPUT_PASSWORD
    CALL STORE_CREDENTIALS
    CALL SIGNUP_SUCCESSFUL
    JMP EXIT

LOGIN:
    ; Get username and password, then validate them
    CALL INPUT_USERNAME
    CALL INPUT_PASSWORD
    CALL VALIDATE_CREDENTIALS
    CMP AL, 1
    JE LOGIN_SUCCESSFUL
    CALL LOGIN_FAILED
    JMP EXIT

USER_ALREADY_EXISTS:
    MOV DX, OFFSET user_exists
    CALL PRINT_STRING
    JMP MAIN

SIGNUP_SUCCESSFUL:
    MOV DX, OFFSET signup_success
    CALL PRINT_STRING
    JMP MAIN

LOGIN_SUCCESSFUL:
    MOV DX, OFFSET login_success
    CALL PRINT_STRING
    JMP MAIN

LOGIN_FAILED:
    MOV DX, OFFSET login_fail
    CALL PRINT_STRING
    JMP MAIN

EXIT:
    MOV AX, 4C00H
    INT 21H

DISPLAY_MENU PROC
    ; Display menu
    MOV DX, OFFSET newline
    CALL PRINT_STRING
    MOV DX, OFFSET username_prompt
    CALL PRINT_STRING
    ; Logic to read input from user and store it in AL register
    ; For now, assume '1' for Signup, '2' for Login
    ; You would use INT 21h with AH = 01h to get a single character input
    MOV AH, 01H
    INT 21H
    RET
DISPLAY_MENU ENDP

INPUT_USERNAME PROC
    ; Prompt and capture the username
    MOV DX, OFFSET username_prompt
    CALL PRINT_STRING
    ; Logic to capture user input
    ; Use INT 21h with AH = 0Ah for buffered input
    LEA DX, current_user
    MOV AH, 0AH
    INT 21H
    RET
INPUT_USERNAME ENDP

INPUT_PASSWORD PROC
    ; Prompt and capture the password
    MOV DX, OFFSET password_prompt
    CALL PRINT_STRING   
    LEA DX, current_password
    MOV AH, 0AH
    INT 21H
    RET
INPUT_PASSWORD ENDP

CHECK_USER_EXISTS PROC
    ; Compare input username with stored ones
    ; AL = 1 if exists, 0 if not
    RET
CHECK_USER_EXISTS ENDP

VALIDATE_CREDENTIALS PROC
    ; Compare input username/password with stored ones
    ; AL = 1 if match, 0 if not
    RET
VALIDATE_CREDENTIALS ENDP

STORE_CREDENTIALS PROC
    ; Store the new username and password in memory
    RET
STORE_CREDENTIALS ENDP

PRINT_STRING PROC
    ; Print the string at DX
    MOV AH, 09H
    INT 21H
    RET
PRINT_STRING ENDP

END MAIN
