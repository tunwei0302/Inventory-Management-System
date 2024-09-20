.model small
.stack
.data

    new_line db 13, 10, '$'

    user db "admin$", 0
    password db "1234$", 0
    
    username_prompt db "Enter Username: $"
    password_prompt db 13, 10, "Enter Password: $"

    input_user      db 20
                    db 0 
                    db 20 dup(0)

    input_password  db 20
                    db 0 
                    db 20 dup(0)

    success_msg     db 13, 10, 'Login successful!$'
    fail_msg        db 13, 10, 'Login failed! Try again.$'

.code
main proc 
    ; initialize variable // set address of data segment 
    mov ax, @data
    mov ds, ax

loginpage:
    call login
    jmp done

login:
    ; Clear input_user buffer manually (replace rep stosb)
    lea di, input_user + 2       ; Point to the start of the input buffer
    mov cx, 20                   ; Set CX to the size of the buffer (20 bytes)
clear_user_buffer:
    mov byte ptr [di], 0         ; Set each byte to 0
    inc di                       ; Move to the next byte
    loop clear_user_buffer        ; Repeat until CX is 0

    ; Clear input_password buffer manually (replace rep stosb)
    lea di, input_password + 2   ; Point to the start of the password buffer
    mov cx, 20                   ; Set CX to the size of the buffer (20 bytes)
clear_password_buffer:
    mov byte ptr [di], 0         ; Set each byte to 0
    inc di                       ; Move to the next byte
    loop clear_password_buffer    ; Repeat until CX is 0

    ; Prompt for username
    mov ah, 09h
    mov dx, offset username_prompt
    int 21h

    LEA dx, input_user
    mov ah, 0Ah
    int 21h

    ; Add null terminator for username input
    mov al, [input_user+1]      ; Number of characters entered is at input_user+1
    xor ah, ah
    lea si, [input_user+2]      ; Point to the first character of the input
    add si, ax                  ; Move to the end of the entered username
    mov byte ptr [si], '$'      ; Add the '$' to terminate the string

    ; Prompt for password
    mov ah, 09h
    mov dx, offset password_prompt
    int 21h

    LEA dx, input_password
    mov ah, 0Ah
    int 21h

    ; Add null terminator for password input
    mov al, [input_password+1]  ; Number of characters entered is at input_password+1
    xor ah, ah
    lea si, [input_password+2]  ; Point to the first character of the input
    add si, ax
    mov byte ptr [si], '$'      ; Add the '$' to terminate the string

    mov ah, 09h
    mov dx, offset new_line
    int 21h
    lea dx, input_user+2
    mov ah, 09h
    int 21h
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    lea dx, user
    mov ah, 09h
    int 21h
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    lea dx, input_password+2
    mov ah, 09h
    int 21h
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    lea dx, password
    mov ah, 09h
    int 21h

    ; Check username
    lea si, [user]            ; Load address of stored username into SI
    lea di, [input_user+2]    ; Load address of input username into DI
    call checkLogin
    
    ; Check password
    lea si, [password]        ; Load address of stored password into SI
    lea di, [input_password+2] ; Load address of input password into DI
    call checkLogin
    
    mov ah, 09h
    mov dx, offset success_msg
    int 21h
    mov dx, offset new_line
    int 21h
    jmp login
    ; jmp done

equal:
    cld
    ret                       ; Return if strings match

checkLogin:
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

failed:
    ; Print failure message
    mov ah, 09h
    mov dx, offset fail_msg
    int 21h
    mov dx, offset new_line
    int 21h
    mov dx, offset new_line
    int 21h
    jmp login             ; Go back to login page

done:
    mov ah, 4Ch               ; Exit program
    int 21h

main endp
end main