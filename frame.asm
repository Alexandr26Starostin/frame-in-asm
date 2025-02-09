;------------------------------------------------------------------------------------------------------------------
;This program takes symbol from video memory and show it in text mode in point (X_0, Y_0)
;
;In this version program print 'SYMBOL' with 'COLOR'
;------------------------------------------------------------------------------------------------------------------
;                                        program

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)
.code         ;begin program
org 100h      ;START == 256:   jmp START == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
START:
	call Put_Sym       ;call func

	mov ax, 4c00h      ;end of program
	int 21h            ;call system
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
;											 Put_Sym
;Draws one char to video memory in (x = X_0, y = Y_0)
;Entry: None
;Exit:  None
;Destr: bx, es
;--------------------------------------------------------------------------------------------------------------

Put_Sym proc           ;mark for func
	mov bx, 0b800h     ;video segment
	mov es, bx         ;register es for segment address of video memory  (es != const    es == reg)

	mov bx, 5 * 80 * 2 + 40 * 2         ;offset in video segment  (2 <= 2 bytes)

	;!!! push ax       ;use ax

	;in text mode in video memory: sizeof (symbol) == 2
	;byte ptr == mov 1 byte  in memory
	;word ptr == mov 2 bytes in memory

	;!!! mov ax, SYMBOL
	mov byte ptr es:[bx],   'A'  ;first byte for symbol's ASCII code
	;!!! mov ax, COLOR
	mov byte ptr es:[bx+1], 11011010b  ;second byte for symbol's color  

	;!!! pop ax      ;save ax

	ret     ;refund of control
	endp    ;end of func
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
;                                      variables
;X_0: dw 40    
;Y_0: dw 5
;LEN_STR: dw 80
;COLOR: db 11011010b
		;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
		; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase

;SYMBOL: db 'A'
;--------------------------------------------------------------------------------------------------------------

end START              ;end of asm and address of program's beginning

