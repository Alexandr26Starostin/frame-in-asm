;------------------------------------------------------------------------------------------------------------------
;This program
;------------------------------------------------------------------------------------------------------------------
;                                        program

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)

;--------------------------------------------------------------------------------------------------------------
;                                      variables
.data 
LEN_STR dw 0080d
COLOR db 01011011b
	    ;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
	    ; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase

;sizes of frame
X_SIZE dw 0010d 
Y_SIZE dw 0006d

Frame_Style_1 db '123456789$'

;--------------------------------------------------------------------------------------------------------------
;										main program
;Entry: None
;Exit:  None
;Destr: si, ah
;--------------------------------------------------------------------------------------------------------------

.code         ;begin program
org 100h      ;START == 256:   jmp START == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
START:
	mov si, offset Frame_Style_1
	mov ah, COLOR
	mov di, 0b800h     ;video segment
	mov es, di         ;register es for segment address of video memory  (es != const    es == reg)
	mov di, 0080d*(0005d)*0002d + 0002d*(0015d)
	mov cx, X_SIZE
	sub cx, 2d

	call Print_Frame       ;call func

	mov ax, 4c00h      ;end of program
	int 21h            ;call system
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 Print_Frame
;Draws frame
;Entry: None
;Exit:  None
;Destr: 
;--------------------------------------------------------------------------------------------------------------

Print_Frame proc          
	mov bx, Y_SIZE           ;bx - index of line  

	call Print_Line 
	dec bx    

	PRINT_NEW_LINE:
		push si
		call Print_Line 
		dec bx
		pop si 

		cmp bx, 1d
		jnz PRINT_NEW_LINE

	add si, 3

	call Print_Line 
	dec bx

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
;											 Print_Line
;Draws one line 

;Entry: 	cx
;			ah
;			di
;			si
;
;Exit:  None
;
;Destr: 	al 
;			di 
;			si
;--------------------------------------------------------------------------------------------------------------

Print_Line proc     

	push cx

	mov al, ds:[si]
	inc si

	mov word ptr es:[di], ax
	add di, 2

	mov al, ds:[si]
	inc si

	Next_Symbol:
		mov word ptr es:[di], ax
		add di, 2
		loop Next_Symbol
	
	mov al, ds:[si]
	inc si

	mov word ptr es:[di], ax
	add di, 2

	pop cx

	add di, 80d * 2d
	sub di, X_SIZE
	sub di, X_SIZE

	ret     
	endp    
;--------------------------------------------------------------------------------------------------------------

end START              ;end of asm and address of program's beginning
