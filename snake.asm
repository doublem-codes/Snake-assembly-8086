
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h 
    mov ax,0b800h
    mov ds,ax   
    mov ax,0
    mov dl, 3  ;colonne
    mov dh, 12   ;righe
    mov [0fa3h],64h
    call selezionalivelli
    call appari_pallini
ciclo:call movimento
    jmp ciclo
exit:ret

movimento proc near  ;la chiamata della funzione è nella stessa pagina (near)
    mov ah,0bh
    int 21h
    cmp al,0ffh ;guardo se e' stato premuto un tasto
    jne carattere
    mov ah,0
    int 16h ;legge il tasto premuto (no echo)
    mov [0fa3h],al ; in al c'e' 0ffh se è stato premuto un tasto
    cmp al,77h 
    je alto
    cmp al,73h
    je basso
    cmp al,64h       
    je destra
    cmp al,78h
    je x
    cmp al,61h
    jne fine
sinistra:call movimento_sx
    jmp fine
basso:call movimento_basso
    jmp fine
alto:call movimento_alto
    jmp fine 
destra:call movimento_dx
    jmp fine
carattere:cmp [0fa3h],77h
    je alto
    cmp [0fa3h],73h
    je basso
    cmp [0fa3h],64h       
    je destra
    cmp [0fa3h],61h
    je sinistra
fine:mov al,0 
    jmp addio
x:  pop di
    jmp exit
addio:mov al,1
    mov bh,0 
    mov bl,0000_1101b
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
movimento endp
    
movimento_sx proc near
    call cancellazione
    cmp dl,0
    jne normales
    add dl,4fh ;se e' all'inizio lo faccio apparire in fondo
    jmp fines
normales:sub dl,1
fines:push si
    mov si,0
    call controllo
    cmp si,1
    jne nons
    call appari_pallini
    pop si
    inc si
    jmp ciaos
nons:pop si
ciaos:call salvataggio 
    ret
movimento_sx endp 

movimento_dx proc near
    call cancellazione
    cmp dl,4fh
    jne normaled
    sub dl,4fh
    jmp fined
normaled:add dl,1
fined:push si
    mov si,0
    call controllo
    cmp si,1
    jne nond
    call appari_pallini
    pop si
    inc si
    jmp ciaod
nond:pop si
ciaod:call salvataggio
    ret
movimento_dx endp 
    
movimento_basso proc near
    call cancellazione
    cmp dh,18h
    jne normaleb
    sub dh,18h
    jmp fineb
normaleb:add dh,1
fineb:push si
    mov si,0
    call controllo
    cmp si,1
    jne nonb
    call appari_pallini
    pop si
    inc si
    jmp ciaob
nonb:pop si
ciaob:call salvataggio
    ret
movimento_basso endp 

movimento_alto proc near
    call cancellazione
    cmp dh,0
    jne normalea
    add dh,18h
    jmp finea
normalea:sub dh,1
finea:push si
    mov si,0
    call controllo
    cmp si,1
    jne nona
    call appari_pallini
    pop si
    inc si
    jmp ciaoa
nona:pop si
ciaoa:call salvataggio
    ret
movimento_alto endp

cancellazione proc near
    push ax
    push bx
    push cx
    push di
    mov ax,0
    mov bx,0
    mov cx,0
    mov di,0fb1h
    cmp si,0
    jne coda
    mov bl,dh  ;numero della riga in bl
    mov al,0a0h ;(160) numero celle riga
    mul bl ;moltiplicazione con al per puntare alla riga successiva
    mov bl,dl
    add ax,bx
    add ax,bx
    mov di,ax  ;indirizzo la cella precedente
    jmp bello
coda:mov cl,[0faeh]
    add di,cx
    inc di
    mov bl,[di]  ;numero della riga in bl
    mov al,0a0h ;(160) numero celle riga
    mul bl ;moltiplicazione con al per puntare alla riga successiva
    sub di,1
    mov bl,[di]
    add ax,bx
    add ax,bx
    mov di,ax  ;indirizzo la cella precedente
bello:mov [di],0 ;cancello la @
    pop di 
    pop cx
    pop bx
    pop ax
    ret
cancellazione endp

appari_pallini proc near
    push cx
    push dx
    push ax
    push bx
    mov bl,0
 bf:push bx
    mov ah,2Ch
    int 21h
    mov al,14h
    mul dl
    mov dx,0
    mov cx,0a0h
    div cx
    mov cx,0   
    mov dh,al
    cmp dh,0
    jne fde
    add dh,2
fde:mov al,1
    mov bh,0 
    mov bl,1010_0001b
    mov cx,msg2end - offset msg2 ; calculate message size.
    push cs
    pop es
    mov bp, offset msg2
    mov ah, 13h
    int 10h
    jmp msg2end
    msg2 db "*" 
    msg2end:
    pop bx
    inc bl
    cmp bl,2
    jne bf
    pop bx
    pop ax
    pop dx
    pop cx
    ret
appari_pallini endp

controllo proc near
    push ax
    push bx
    push cx
    push di
    mov ax,0
    mov bx,0
    mov cx,0
    mov di,0
    mov bl,dh  ;numero della riga in bl
    mov al,0a0h ;(160) numero celle riga
    mul bl ;moltiplicazione con al per puntare alla riga successiva
    mov bl,dl
    add ax,bx
    add ax,bx
    mov di,ax  ;indirizzo la cella precedente
    cmp [di],"*" 
    jne vuota
    inc si
vuota:cmp [di],"@"
    jne dfe
    pop di 
    pop cx
    pop bx
    pop ax
    pop dx
    ret
dfe:pop di 
    pop cx
    pop bx
    pop ax
    ret
controllo endp

salvataggio proc near
    push ax
    push cx
    push bx
    push di
    push si
    mov bx,si
    mov ax,2
    mul bl
    mov di,0fb1h
    mov si,0fb2h 
    mov bx,0
    push [di]
    mov [di],dl
    mov [si],dh
    add di,2
    add si,2
ciclosal:cmp al,ah
    je finesalto
    pop bx
    push [di]
    mov [di],bl
    mov [si],bh
    add ah,2
    add di,2
    add si,2
    jmp ciclosal
finesalto:pop di
finesal:mov [0faeh],ah
    pop si
    pop di
    pop bx
    pop cx
    pop ax
    ret
salvataggio endp
             
selezionalivelli proc near
    push dx
    push ax
    push bx
    mov ax, 0b800h
    mov ds,ax 
    mov [0fa4h],1
    mov bx,1
    mov bl,0000_1011b
    mov dh,0  
    mov al,1
    mov bh,0 
    mov cx,msg3end - offset msg3
    push cs
    pop es
    mov bp, offset msg3
    mov ah, 13h
    int 10h
    jmp msg3end
    msg3 db "seleziona livello" 
    msg3end:
    mov bl,1000_1011b
    call livello_1
    mov bl,0000_1011b
    call livello_2
    call livello_3
    ciclosel:
    mov ah,0
    int 16h  
    cmp al,77h 
    jne aschi
    mov al,[0fa4h]
    cmp al,0
    je ciclosel
    dec [0fa4h]
    jmp finelistaa
aschi:cmp al,73h 
    jne enter
    inc [0fa4h] 
    jmp finelista
enter:cmp al,'e'
    jne ciclosel
    mov ah,0
    mov al,[0fa4h]
    mov bl,3
    div bl
    cmp ah,1
    jne e
    pop bx
    pop ax
    pop dx
    call disegno1
e:  cmp ah,2
    jne f
    pop bx
    pop ax
    pop dx
    call disegno2
f:  cmp al,1
    jne ciclosel
    pop bx
    pop ax
    pop dx
    call disegno3    
finelistaa:mov ah,0
    mov al,[0fa4h]
    mov bl,3
    div bl
    cmp ah,1
    jne a
    mov bl,0000_1011b
    call livello_2
    mov bl,1000_1011b
    call livello_1 
    jmp ciclosel
a:  cmp ah,2
    jne b
    mov bl,0000_1011b
    call livello_3                           
    mov bl,1000_1011b
    call livello_2
    jmp ciclosel
b:  cmp ah,3
    mov bl,0000_1011b
    call livello_1
    mov bl,1000_1011b
    call livello_3
    jmp ciclosel
finelista:mov ah,0
    mov al,[0fa4h]
    mov bl,3
    div bl
    cmp ah,1
    jne c
    mov bl,0000_1011b
    call livello_3
    mov bl,1000_1011b
    call livello_1 
    jmp ciclosel
c: cmp ah,2
    jne d
    mov bl,0000_1011b
    call livello_1                           
    mov bl,1000_1011b
    call livello_2
    jmp ciclosel
d: cmp ah,3
    mov bl,0000_1011b
    call livello_2
    mov bl,1000_1011b
    call livello_3
    jmp ciclosel
    pop bx
    pop ax
    pop dx
    ret
selezionalivelli endp

livello_1 proc near
    mov dh,2   
    mov al,1
    mov bh,0 
    mov cx,msg4end - offset msg4
    push cs
    pop es
    mov bp, offset msg4
    mov ah, 13h
    int 10h
    jmp msg4end
    msg4 db "LIVELLO1" 
    msg4end: 
    ret
livello_1 endp

livello_2 proc near 
    mov dh,4 
    mov al,1
    mov bh,0 
    mov cx,msg5end - offset msg5
    push cs
    pop es
    mov bp, offset msg5
    mov ah, 13h
    int 10h
    jmp msg5end
    msg5 db "LIVELLO2" 
    msg5end:
    ret 
livello_2 endp

livello_3 proc near
    mov dh,6
    mov al,1
    mov bh,0 
    mov cx,msg6end - offset msg6
    push cs
    pop es
    mov bp, offset msg6
    mov ah, 13h
    int 10h
    jmp msg6end
    msg6 db "LIVELLO3" 
    msg6end:
    ret
livello_3 endp

disegno1 proc near
    pop di
    push dx
    mov di,0
    mov dx,0
ch1:mov [di],0
    inc dx
    inc di
    cmp dx,0fa0h
    jne ch1
    mov [0fb0h],0                                                  
    mov dx,0                                                               
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
        pop dx                                                 
        ret
disegno1 endp
      
      
disegno2 proc near
    pop di
    push dx
    mov di,0
    mov dx,0
ch2:mov [di],0
    inc dx
    inc di
    cmp dx,0fa0h
    jne ch2
    mov [0fb0h],0                                                  
    mov dx,0
ciclo12:

    call testo
    inc dl
    inc dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo12
    
    call azzeramento2
    mov [0fb0h],0
        
ciclo22:

    call testo
    inc dh
    dec dl
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo22
    
    call azzeramento3
    mov [0fb0h],0

ciclo32:
    
    call testo
    inc dl
    dec dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo32
    
    call azzeramento4
    mov [0fb0h],0 

ciclo42:
    
    call testo
    dec dl
    dec dh
    inc [0fb0h]
    cmp [0fb0h],10
    jne ciclo42
    
    call azzeramento5
    mov [0fb0h],0 
                
ciclo92:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo92
    
    call azzeramento6
    mov [0fb0h],0 
    
ciclo52:
    call testo
    inc dh
    inc [0fb0h]
    cmp [0fb0h],15
    jne ciclo52
    pop dx        
    ret
disegno2 endp

disegno3 proc near
    pop di
    push dx
    mov di,0
    mov dx,0
ch3:mov [di],0
    inc dx
    inc di
    cmp dx,0fa0h
    jne ch3
    mov [0fb0h],0                                                  
    mov dx,0 
ciclo13:

    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo13
    
    call azzeramento1
    mov [0fb0h],0
        
ciclo23:

    call testo
    inc dh
    inc [0fb0h]
    cmp [0fb0h],24
    jne ciclo23
    
    call azzeramento2
    mov [0fb0h],0
    
ciclo33:
    call testo
    inc dh
    inc [0fb0h]
    cmp [0fb0h],24
    jne ciclo33
    
    call azzeramento2
    mov [0fb0h],0    
    
ciclo43:
    call testo
    dec dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo43

    call azzeramento3
    mov [0fb0h],0    
    
ciclo53:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo53
    
    call azzeramento3
    mov [0fb0h],0
    
ciclo63:
    call testo
    dec dh
    inc [0fb0h]
    cmp [0fb0h],24
    jne ciclo63
    
    call azzeramento4
    mov [0fb0h],0

ciclo73:
    call testo
    dec dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo73
    
    call azzeramento5
    mov [0fb0h],0 
    
ciclo93:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo93
    
    call azzeramento7
    mov [0fb0h],0 
    
ciclo103:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo103
    
    call azzeramento8
    mov [0fb0h],0 
    
ciclo113:
    call testo
    inc dl
    inc [0fb0h]
    cmp [0fb0h],40
    jne ciclo113
    pop dx
    ret        
disegno3 endp

testo proc near
        
    mov al,1
    mov bh,0 
    mov bl,0000_1001b
    mov cx,msg7end - offset msg7 ; calculate message size.
    push cs
    pop es
    mov bp, offset msg7
    mov ah, 13h
    int 10h
    jmp msg7end
    msg7 db "@" 
    msg7end:
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

azzeramento6 proc near
    
    mov dh,5
    mov dl,39
ret
endp azzeramento6

azzeramento7 proc near
    
    mov dh,20
    mov dl,19
ret
endp azzeramento7

azzeramento8 proc near
    
    mov dh,4
    mov dl,19
ret
endp azzeramento8

    