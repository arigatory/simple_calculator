MAXN equ 128

function MACRO function_name,arg1
    lea ax,arg1
    push ax
    call function_name
ENDM

org 100h
    
    function print_string msg_hello
    
    function print_string msg_x
    
    function read_string x
    
    call newline
    
    function print_string msg_Y
    
    function read_string y
    
    call newline
    
    function print_string x
    function print_string msg_plus
    function print_string y
    function print_string msg_res
    
    function reverse x
    function reverse y
    
    
    cld
    lea si,x
    lea di,z
    push si         ; arg1 = x
    call count_length
    mov cx,ax       ; cx = length(x)
    xor ax,ax
    xor bx,bx
ll: lodsb
    ; some action here
    stosb
    loop ll
    
    
    lea si,y
    push si
    xor ax,ax
    lea di,z
l2: mov al,[si]
    inc si
    cmp al,0
    je next_digit
    sub al,'0'
next_digit:
    add al,[di]
    add al,bl       ;add carry
    xor bx,bx
    cmp al,'0'+9
    jbe no_carry
    sub al,10
    mov bl,1
no_carry:
    cmp al,'0'
    jae store
    add al,'0'
store:
    mov [di],al
    inc di
    cmp [si],0
    jnz l2
    cmp [di],0
    jnz l2
    cmp bl,0
    jnz l2    
    
    
    function reverse z
    function print_string z   
    
    call newline
                     
    jmp $

    
    
    
;MY Strings


msg_hello db 'Hello, this as a simple calculator',10,13,0
msg_x db 'Please enter X: ',0
msg_y db 'Please enter Y: ',0
msg_res db ' = ',0
msg_plus db ' + ',0
msg_newline db 10,13,0



;MY FUNCTIONS



;count length of 0-terminated string
count_length: 
    push bp
    mov bp,sp
    push si
    push bx
     
    mov si,[bp+4]           ; si = arg1
    xor bx,bx               ; count number in bx
next_byte_null_check:
    cmp byte ptr[si+bx],0
    je exit_count
    inc bx
    jmp next_byte_null_check
    

exit_count:    
    mov ax,bx   ; ax = length(arg1)
    pop bx
    pop si
    pop bp
    ret 2
    
    

newline:
    push ax
    lea ax,msg_newline
    push ax
    call print_string
    pop ax
    ret 



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
    mov di,si           ;di = si + bx - 1
    add di,bx            ;
    dec di               ; di looks at last char
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
    
    pop bp
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
    x db MAXN dup(0)
    y db MAXN dup(0)
    z db MAXN dup(0)
    reverse_x MAXN dup(0)
    reverse_y MAXN dup(0)
    reverse_z MAXN dup(0)