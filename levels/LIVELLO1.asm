
org 100h
mov [0fb0h],0
    
ciclo1:

    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo1
    
    call azzeramento1
    mov [0fb0h],0
        
ciclo2:

    call testo
    inc dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo2
    
    call azzeramento2
    mov [0fb0h],0
    
ciclo3:
    call testo
    inc dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo3
    
    call azzeramento2
    mov [0fb0h],0    
    
ciclo4:
    call testo
    dec dl
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo4

    call azzeramento3
    mov [0fb0h],0    
    
ciclo5:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo5
    
    call azzeramento3
    mov [0fb0h],0
    
ciclo6:
    call testo
    dec dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo6
    
    call azzeramento4
    mov [0fb0h],0

ciclo7:
    call testo
    dec dl
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo7
    
    call azzeramento4
    mov [0fb0h],0
    
ciclo8:
    call testo
    dec dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo8
    
    call azzeramento5
    mov [0fb0h],0
    
ciclo9:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo9    
    
           
             

ret 
    
testo proc near
        
    mov al,1
    mov bh,0 
    mov bl,0000_1001b
    mov cx,msg1end - offset msg1 ; calculate message size.
    push cs
    pop es
    mov bp, offset msg1
    mov ah, 13h
    int 10h
    jmp msg1end
    msg1 db "@" 
    msg1end:
ret
endp testo 

azzeramento1 proc near
    
    mov dh,0
    mov dl,0
ret
endp azzeramento1

azzeramento2 proc near
    
    mov dh,0
    mov dl,79
ret
endp azzeramento 2

azzeramento3 proc near
    
    mov dh,24
    mov dl,0
ret
endp azzeramento3

azzeramento4 proc near
    
    mov dh,24
    mov dl,79
ret
endp azzeramento4

azzeramento5 proc near
    
    mov dh,12
    mov dl,19
ret 
endp azzeramento5
        
    
    




