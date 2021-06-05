org 100h

; add your code here
    lea ax,msg_hello
    push ax
    call print_string
     
    lea ax,msg_X
    push ax
    call print_string 
    
    lea ax,x
    push ax        
    call read_string    ; x = 'input'
    
    lea ax,msg_newline
    push ax
    call print_string
    
    
    lea ax,msg_Y
    push ax
    call print_string
    
    lea ax,y
    push ax        
    call read_string    ; y = 'input'
    
    lea ax,msg_newline
    push ax
    call print_string
    
     
     
    lea ax,x
    push ax
    call print_string
    
    lea ax,msg_plus
    push ax
    call print_string
    
    lea ax,y
    push ax
    call print_string
    
    lea ax,msg_res
    push ax
    call print_string                                  
    
    lea ax,x
    push ax
    call reverse
                     
    jmp $

    
    
    
;MY Strings


msg_hello db 'Hello, this as a simple calculator',10,13,0
msg_x db 'Please enter X: ',0
msg_y db 'Please enter Y: ',0
msg_res db ' = ',0
msg_plus db ' + ',0
msg_newline db 10,13,0



;MY FUNCTIONS


;revers 0-terminated data 1230 -> 3210
reverse:
    push bp
    mov bp,sp
    mov si,[bp+4]
    xor bx,bx               ; count number in bx
next_data:
    cmp byte ptr[si+bx],0
    je exit_reverse
    inc bx
    jmp next_data
exit_reverse:
    mov di,[si+bx-1]
swap_loop: 
    mov al,[di]
    mov cl,[si]
    mov [si],al
    mov [di],cl
    inc si
    dec di
    cmp si,di
    jae exit_swap
    jmp swap_loop

exit_swap:
    
    ret 2
    


print_string:
    push bp
    mov bp,sp
    mov si,[bp+4]     
next_char:
    cmp  byte ptr [si], 0    ; check for zero to stop
    je   stop         ;

    mov  al, [si]     ; next get ASCII char.

    mov  ah, 0Eh      ; teletype function number.
    int  10h          ; using interrupt to print a char in AL.

    add  SI, 1        ; advance index of string array.

    jmp  next_char    ; go back, and type another char.

stop:
    pop bp
    ret 2                   ; return to caller.




;reads user input to buf (arg1 in stack)
read_string:
    push bp
    mov bp,sp
    push dx
    push bx
    push cx
    push ax
    push si
    
    xor dx,dx
    xor bx,bx
    mov cx,10
    mov si,[bp+4]
l:
    call read_key
    cmp ax,1C0Dh  ; enter pressed
    je exit_l
    
    mov ah,0
    mov dx,ax
    mov [si+bx],dl
    sub dx,'0'
    inc bx
    push ax
    call print_char ; prints one char from stack
    loop l
    
exit_l:        
    pop si
    pop ax
    pop cx
    pop bx
    pop dx
    pop bp  
    ret 2
    
    
read_key:
    xor ax,ax
    int 16h
    ret

print_char:  
    push bp
    mov bp,sp
    push ax
    
    mov ax,[bp+4]   ;char to print -> al
    mov ah,0xE      ;teletype function
    
    int 10h         ;output
    
    pop ax
    pop bp
    ret 2


;MY DATA
    x db 64 dup(0)
    y db 64 dup(0)
    z db 64 dup(0)