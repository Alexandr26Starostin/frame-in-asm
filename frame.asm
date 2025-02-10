;------------------------------------------------------------------------------------------------------------------
;This program takes symbol from video memory and show it in text mode in point (X_0, Y_0)
;
;In this version program print 'SYMBOL' with 'COLOR'
;------------------------------------------------------------------------------------------------------------------
;                                        program

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)

;--------------------------------------------------------------------------------------------------------------
;                                      variables
X_0 = 40d    
Y_0 = 5d
LEN_STR = 80d
COLOR = 11011010b
	   ;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
	   ; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase

SYMBOL = 'A'
;--------------------------------------------------------------------------------------------------------------

.code         ;begin program

org 100h      ;START == 256:   jmp START == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
START:
	call Put_Sym       ;call func

	mov ax, 4c00h      ;end of program
	int 21h            ;call system
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
;											 Put_Sym
;Draws one char 'SYMBOL' with 'COLOR' to video memory in (x = X_0, y = Y_0)
;Entry: None
;Exit:  None
;Destr: bx, es
;--------------------------------------------------------------------------------------------------------------

Put_Sym proc           ;mark for func
	mov bx, 0b800h     ;video segment
	mov es, bx         ;register es for segment address of video memory  (es != const    es == reg)

	mov bx, Y_0 * 80 * 2 + X_0 * 2         ;offset in video segment  (2 <-- 2 bytes)

	;in text mode in video memory: sizeof (symbol) == 2
	;byte ptr == mov 1 byte  in memory
	;word ptr == mov 2 bytes in memory

	mov byte ptr es:[bx],   SYMBOL  ;first byte for symbol's ASCII code
	mov byte ptr es:[bx+1], COLOR   ;second byte for symbol's color  

	ret     ;refund of control
	endp    ;end of func
;--------------------------------------------------------------------------------------------------------------


end START              ;end of asm and address of program's beginning

