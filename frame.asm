;------------------------------------------------------------------------------------------------------------------
;This program draw frame
;------------------------------------------------------------------------------------------------------------------
;                                        program

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)

;--------------------------------------------------------------------------------------------------------------
;                                      variables
.data 
color db 00000000b
	    ;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
	    ; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase

x_size dw 0000d   ;horizontal sizes of frame
y_size dw 0008d   ;vertical   sizes of frame

frame_style db '123456789$'

;--------------------------------------------------------------------------------------------------------------
;										main program
;Entry: None
;Exit:  None
;Destr: None
;--------------------------------------------------------------------------------------------------------------

.code         ;begin program
org 100h      ;start == 256:   jmp start == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
start:
	mov di, 0b800h     ;video segment
	mov es, di         ;register es for segment address of video memory  (es != const    es == reg)

	call atoi
	mov x_size, ax     ;x_size = ax = horizontal size of frame

	;call atoi
	;mov y_size, ax     ;y_size = ax = vertical   size of frame

	call count_left_high_point   

	call atob     ;ah = color       

	mov si, offset frame_style  ;si = address on line with style               
	mov cx, x_size
	sub cx, 0002d        ;cx = x_size - 2 = len of str with recurring symbol 

	call print_frame  

	mov ax, 4c00h      ;end of program with returned code = 0
	int 21h            ;call system
;--------------------------------------------------------------------------------------------------------------




;--------------------------------------------------------------------------------------------------------------
;											 atoi
;translate str to 2 bytes int (dec number) (but it can not do this operation on this version)

;Entry: None (on this version)
;
;Exit:  ax = int number from str
;
;Destr: ax = reading int from str
;--------------------------------------------------------------------------------------------------------------

atoi proc          
	mov ax, 0030d

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 count_left_high_point
;Count coordinates of left high point of frame
;
;Entry: x_size = horizontal size of frame
;		y_size = vertical   size of frame
;
;Exit:  di = address in video memory for left high of frame
;  
;Destr: ax = calculations
;		bx = logical  left coordinate
;       cx = logical  high coordinate
;       si = physical left address
;       di = physical high address and address of point in video memory 
;--------------------------------------------------------------------------------------------------------------

count_left_high_point proc     

	;center point:   0080d*(0008d)*0002d + 0002d*(0038d)

	mov ax, x_size
	shr ax, 1
	mov bx, 0038d    
	sub bx, ax       ;bx = 0038d - x_size / 2

	mov ax, 0002d
	mul bx
	mov	si, ax       ;si = 0002d * bx = 0002d * (0038d - x_size / 2)   - left point

	mov ax, y_size
	shr ax, 1
	mov cx, 0008d
	sub cx, ax      ;cx = 0008d - y_size / 2

	mov ax, 0160d
	mul cx
	mov di, ax      ;di = cx * 0160d = 0002d * 0080d * (0008d - y_size / 2)   - high point

	add di, si      ;di = 0002d*0080d*(0008d - y_size / 2) + 0002d*(0038d - x_size / 2) - left high point in Video memory 

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 atob
;translate str to 1 byte int (bin number) (but it can not do this operation on this version)

;Entry: None (on this version)
;
;Exit:  ah = int number from str
;
;Destr: ah = reading int from str
;--------------------------------------------------------------------------------------------------------------

atob proc          
	mov ah, 01011011b

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 print_frame
;Draws frame x_size * y_size in frame_style and color
;
;Entry: ah = color
;		cx = x_size - 2 = len of str with recurring symbol 
;		si = address on line with style / on the first set of symbols (for the first line)
;		di = address of point in video memory (in video segment)
;		es = segment address of video memory
;
;Exit: None 
;
;Destr: bx = index of lines
;		si = address on different sets of symbols from line with style 
;--------------------------------------------------------------------------------------------------------------

print_frame proc          
	mov bx, y_size        ;bx - index of line  (max value = y_size, step = -1, min value = 0)

	call print_line       ;draw the first line of frame with the first set of symbols
	dec bx        

	print_new_line:       ;for (bx = y_size - 1; bx > 1; bx--) {printf ("%s\n", middle_line);}

		push si           ;save address on the second set of symbols (for the middle lines)
		call print_line   ;draw the middle line
		dec bx
		pop si             

		cmp bx, 1d
		jnz print_new_line

	add si, 3            ;address on the third set of symbols (for the last line)

	call print_line      ;draw the last line of frame
	dec bx

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
;											 print_line
;Draws one line with someone set of symbols 

;Entry: cx = x_size - 2 = len of str with recurring symbol 
;		ah = color
;		di = address of point in video memory (in video segment)
;		si = address on set of symbols                                         
;
;Exit:  None
;
;Destr: al 
;		di 
;		si
;--------------------------------------------------------------------------------------------------------------

print_line proc     

	push cx      ;save len of str with recurring symbol 

	mov al, ds:[si]    ;al = the first symbol in set
	inc si

	mov word ptr es:[di], ax   ;put symbol and his color (ax) in video memory by address = es[di]
	add di, 2

	mov al, ds:[si]    ;al = the second symbol in set
	inc si

	next_symbol:  ; while (cx--) {printf ("%c", ax);}    //ax = second symbol with color 
		mov word ptr es:[di], ax
		add di, 2
		loop next_symbol
	
	mov al, ds:[si]     ;al = the third symbol in set
	inc si

	mov word ptr es:[di], ax
	add di, 2

	pop cx

	add di, 80d * 2d   
	sub di, x_size
	sub di, x_size      ;count new address of new line in frame <==> '\n'

	ret     
	endp    
;--------------------------------------------------------------------------------------------------------------

end start              ;end of asm and address of program's beginning
