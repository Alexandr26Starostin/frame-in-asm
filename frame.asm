;------------------------------------------------------------------------------------------------------------------
;This program takes symbol from video memory and show it in text mode in point (X_0, Y_0)
;
;In this version program print 'SYMBOL' with 'COLOR'
;------------------------------------------------------------------------------------------------------------------
;                                        program

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)

;--------------------------------------------------------------------------------------------------------------
;                                      variables
X_0 = 15d      ;min X coordinates in frame
Y_0 = 5d       ;min Y coordinates in frame
LEN_STR = 80d
COLOR = 01101000b
	   ;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
	   ; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase

SYMBOL = ' '

;sizes of frame
X_SIZE = 10d 
Y_SIZE = 3d

;--------------------------------------------------------------------------------------------------------------

.code         ;begin program

org 100h      ;START == 256:   jmp START == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
START:
	call Print_Frame       ;call func

	mov ax, 4c00h      ;end of program
	int 21h            ;call system
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 Print_Frame
;Draws frame from (X_0, Y_0) to sizes: X_SIZE, Y_SIZE
;Entry: None
;Exit:  None
;Destr: bx, es, dx, ax
;--------------------------------------------------------------------------------------------------------------

Print_Frame proc          
	mov dx, Y_0          ;dx - index of line

	mov bx, 0b800h     ;video segment
	mov es, bx         ;register es for segment address of video memory  (es != const    es == reg)

	PRINT_NEW_LINE:
		
		mov ax, 80d * 2d           ;bx = 2 * 80 * dx + 2 * X_0
		push dx
		mul dx
		pop dx
		add ax, 2 * X_0 

		mov bx, ax          ;offset in video segment  (2 <-- 2 bytes)

		call Print_Line 
		add dx, 1d

		cmp dx, Y_0 + Y_SIZE
		jnz PRINT_NEW_LINE

	ret     
	endp   
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
;											 Print_Line
;Draws one line that has chars 'SYMBOL' with 'COLOR' to video memory from (X_0, Y_0) to len = X_SIZE
;Entry: None
;Exit:  None
;Destr: cx, bx 
;--------------------------------------------------------------------------------------------------------------

Print_Line proc         

	;in text mode in video memory: sizeof (symbol) == 2
	;byte ptr == mov 1 byte  in memory
	;word ptr == mov 2 bytes in memory

	mov cx, 0     ;cx - counter of symbols

	PRINT_SYMBOLS:
		mov byte ptr es:[bx],   SYMBOL  ;first byte for symbol's ASCII code
		mov byte ptr es:[bx+1], COLOR   ;second byte for symbol's color  

		add cx, 1d
		add bx, 2d

		cmp cx, X_SIZE
		jnz PRINT_SYMBOLS

	ret     
	endp    
;--------------------------------------------------------------------------------------------------------------

Frame_Style_1 db '123456789$'

end START              ;end of asm and address of program's beginning

