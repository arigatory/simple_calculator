org 100h

; add your code here

    lea ax,x
    push ax        
    call read_string    ; x = 'input'
    
    lea ax,y
    push ax        
    call read_string    ; x = 'input'

    jmp $


;MY FUNCTIONS

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
    mov ah,0
    mov dx,ax
    sub dx,'0'
    mov [si+bx],dl
    inc bx
    push ax
    call print_char ; prints one char from stack
    loop l
    
    
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