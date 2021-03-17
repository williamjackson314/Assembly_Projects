	AREA    |.text|, CODE, READONLY, ALIGN=2
	PRESERVE8
	REQUIRE8
	THUMB
	EXPORT sorttuples 

;R0 will contain the base address, R1 the number of elements to sort
sorttuples
	MOV R8, #0		;swap counter
	MOV R9, R1		;sorttuples_forloop iterator
	
	SUB R9, R9, #1 ;Decrease number, since we compare the current with 
				   ; the next and want to only compare items in the given range
	
	;Store values of needed registers > R3
	PUSH{R4}
	PUSH{R5}
	PUSH{R6}
	PUSH{R7}
	PUSH{R8}
	
	MOV R3, R0
	B sorttuples_forloop
	
sorttuples_forloop
	
	
	LDR R2, [R3]

	;Shift and mask value to isolate y value of current tuple
	LSR R2, R2, #8
	AND R2, R2, #0xFF
	
	;Shift value to isolate y value of next tuple
	LDR R7, [R3]
	LSR R7, R7, #24

	CMP R2, R7
	BGT sorttuples_swap
    
	ADD R3, R3, #0x2
	SUBS R9, R9, #1
	
	BGT sorttuples_forloop
	
	B sorttuples_whileloop
	
sorttuples_swap
	
	ADDS R6, R3, #0x2	;add 2 bytes to current tuple to find address of next tuple
	LDRH R4, [R3] 	;move current tuple into temp variable
	
	LDRH R5, [R6]	;store next tuple in temp variable
	STRH R5, [R3]	;store value at R6 into address of R3
	
	STRH R4, [R6]	;store old value of R3 into R6 
	
	ADDS R8, R8, #1 	;Update swap count
	
	B sorttuples_forloop
	
sorttuples_whileloop
	
	MOV R3, R0	;Reset R3 to address of start of tuple 

	CMP R8, #0
	
	MOV R8, #0		;Reset swap counter
	MOV R9, R1 		;Reset iterator
	
	SUB R9, R9, #1  ;Decrease number, since we compare the current with 
				    ; the next and want to only compare items in the given range
	
	BNE sorttuples_forloop
	
	;Restore values of used registers > R3
	POP{R8}
	POP{R7}
	POP{R6}
	POP{R5}
	POP{R4}
	
	BX LR
	END