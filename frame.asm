;------------------------------------------------------------------------------------------------------------------
;This program takes symbol from video memory and show it in text mode in left high corner of console
;
;In this version program print 'A' with bright green color on violet back ground with blink
;------------------------------------------------------------------------------------------------------------------

.model tiny   ;64 kilobytes in RAM, address == 16 bit == 2 bytes (because: sizeof (register) == 2 bytes)
.code         ;begin program
org 100h      ;START == 256:   jmp START == jmp 256 != jmp 0 (because address [0;255] in program segment in DOS for PSP)
START:

	mov bx, 0b800h     ;video segment
	mov es, bx         ;register es for segment address of video memory  (es != const    es == reg)

	mov bx, 0          ;offset = 0

	;in text mode in video memory: sizeof (symbol) == 2
	;byte ptr == mov 1 byte  in memory
	;word ptr == mov 2 bytes in memory
	mov byte ptr es:[bx],   'A'       ;first byte for symbol's ASCII code
	mov byte ptr es:[bx+1], 11011010b ;second byte for symbol's color  
						   ;bBBBFFFF	b == blink;  B == back ground;  F == for ground       
						   ; rgbIRGB	r/R == red;  g/G == green;  b/B == blue;  I == increase
	
	mov ax, 4c00h      ;end of program
	int 21h

end START              ;end of asm and address of program's beginning

