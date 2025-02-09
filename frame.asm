;
;
;

.model tiny
.code
org 100h
START:

	mov ax, 4c00h
	int 21h

end START