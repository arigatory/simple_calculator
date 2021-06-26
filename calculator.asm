MAXN equ 128

function MACRO function_name, arg1
    lea ax,arg1
    push ax
    call function_name
ENDM


function2 MACRO function_name, arg1, arg2
    lea ax,arg2
    push ax
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
    
    
    function2 make_raw x reverse_raw_x
    function2 make_raw y reverse_raw_y
    
    function2 sum_raw reverse_raw_x reverse_raw_y
    
    function print_raw reverse_raw_x
     
    
    jmp $
    RET
    

    

    
    
;MY Strings


msg_hello db 'Hello, this as a simple calculator',10,13,0
msg_x db 'Please enter X: ',0
msg_y db 'Please enter Y: ',0
msg_res db ' = ',0
msg_plus db ' + ',0
msg_newline db 10,13,0



;MY FUNCTIONS

print_raw:
    push bp
    mov bp,sp
    mov si,[bp+4]     ;si = raw
    mov di, si
    
    next_raw_data:
    cmp byte ptr[si],-1
    je end_of_raw
    inc si
    jmp next_raw_data
    
         
  end_of_raw:
    dec si
  print_next_raw:
    cmp  si, di       ; check for zero to stop
    je   print_last_raw         ;
    mov  al, [si]     ; next get ASCII char.
    add  al, '0'
    
    mov  ah, 0Eh      ; teletype function number.
    int  10h          ; using interrupt to print a char in AL.

    dec  si           ; advance index of string array.

    jmp  print_next_raw    ; go back, and type another char.

  print_last_raw:
  
    mov  al, [si]     ; next get ASCII char.
    add  al, '0'
    
    mov  ah, 0Eh      ; teletype function number.
    int  10h          ; using interrupt to print a char in AL.
  
    pop bp
    ret 2                   ; return to caller.






sum_raw:
    push bp
    mov bp,sp
    mov si,[bp+4]           ; si = x
    mov di,[bp+6]           ; di = y
                   
    
    ;TODO + or -
    
    xor bx,bx       ;bx = carry 
  next_sum: 
    mov al,[si]
    add al,[di]
    add al,bl       ;add carry
    xor bx,bx
    cmp al,9
    jbe no_carry
    sub al,10
    mov bl,1
  no_carry:
    mov [si],al
    inc di
    inc si
    cmp byte ptr [si],-1
    jne check_di
    mov byte ptr [si],0
check_di:
    cmp byte ptr [di],-1
    jne next_sum   
    mov byte ptr [di],0
    
    cmp bl,0
    jnz next_sum    
    
    ;remove leading zeros
next_zero_check:    
    cmp byte ptr[si],0
    jne return_sum
    mov byte ptr[si],-1
    dec si
    jmp next_zero_check

return_sum:
    pop bp
    ret 4 





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



;revers 0-terminated data 1230 -> 3210  in the same memory
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
    


;revers 0-terminated data "1230" -> <+-> 3,2,1,-1, 0, 0, 0, 0, ...     in different memory
make_raw:
    push bp
    mov bp,sp
    mov si,[bp+4]
    mov di,[bp+6]
    xor bx,bx               ; count number in bx
    cmp [si],'-'            ; check if input string is negative
    jne continue_count
    mov [di-1],'-'          ; replace sign before the number <-,+> 123, + is default
    inc si
  continue_count:
    cmp byte ptr[si+bx],0
    je exit_make_raw
    inc bx
    jmp continue_count
  exit_make_raw:
    ;mov di,[bp+6]
  next_swap_raw: 
    dec bx
    mov al,[si+bx]
    sub al,'0'
    mov [di],al
    inc di
    cmp bx,0
    je exit_make_raw_swap
    jmp next_swap_raw

  exit_make_raw_swap:

    pop bp
    ret 4





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
    mov cx,MAXN
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
    
    sign_x db '+'
    reverse_raw_x MAXN dup(-1)
    sign_y db '+'
    reverse_raw_y MAXN dup(-1)
    sign_z db '+'
    reverse_raw_z MAXN dup(-1)
    