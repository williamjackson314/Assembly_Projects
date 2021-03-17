
GPIO_PORTF_DATA_R  EQU 0x400253FC

	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
	EXPORT  Start
	EXPORT 	Example_Function
	EXPORT 	Part3_Function
	EXPORT	Part4_Function
	IMPORT	delay
	IMPORT	leds_off
	IMPORT  PortF_Init
	IMPORT	Example
	IMPORT	Part3
	IMPORT  Part4
		
Start
	BL PortF_Init 	; Initialize the LEDs and Pushbuttons
	BL debug		; Useful for parts 2 and 3
loop
	LDR R1, =GPIO_PORTF_DATA_R
	LDR R0, [R1]
	AND R0, #0x11	;Get just the pushbutton values
	CMP R0, #0x11	;No buttons pressed?
	BNE checkSW1
	BL Example
	B loop
checkSW1
	CMP R0, #0x01 	;SW1 pressed?
	BNE checkSW2
	BL Part3
	B blink
checkSW2
	CMP R0, #0x10 	;SW2 pressed?
	BL Part4
	B blink

	
	;Create blinking effect
blink
	BL delay
	BL leds_off
	BL delay

	B loop


X		EQU 0x00000006
Y		EQU 0xFFFFFFFB
Z		EQU 0x7FFFFFFF

debug

	;Part 1
	MOV R0, X
	MOV R1, Y
	MOV R2, Z
	
	
	ADDS R3, R0, R1
	SUBS R3, R0, R0
	ADDS R3, R0, R2
	SUBS R3, R1, R2
	ADDS R3, R1, R2

	
	;Part 2
	MOV R7, #0x20000000

	LDR R6, [R7]
	
	LDRH R6, [R7]
	
	LDRB R6, [R7]
	
	LDRSH R6, [R7]
	
	LDRSB R6, [R7]

	BX LR

; Returns Z = A+B
; A and B are in R0 and R1, respectively
; Z should be placed in R0
Example_Function
	ADD R0, R0, R1 ;Comment out this instruction to see the Example fail
	BX LR


; Should return Z = (A << 5)|(B & 12)
; Assume A and B are in R0 and R1, respectively
; The value of Z should be placed in R0 at the end
Part3_Function
	;Your Part 3 Code Here
	
	LSL R0, R0, #5
	AND R1, R1, #12
	ORR R0, R0, R1
	
	BX LR
	
	
; Should return Fib[n] (the nth number in the Fibonacci sequence) 
; Assume n is in R0
; The result should be placed in R0 at the end
Part4_Function
	;Your Part 4 Code Here	
	
	MOV R2, #1
	MOV R3, #0
	
	SUBS R0, R0, #0x0		; see if n = 0
	BNE fib_loop    ; if n != 0, go to loop
	
	MOV R0, #0		; if n == 0, then return 0
	
	BX LR
	
fib_loop

	ADD R4, R2, R3	; add previous two numbers, store in R1
	
	MOV R3, R2		; shift values to the next two fib numbers
	MOV R2, R4
	
	
	SUBS R0, R0, #1 ; increment n downward
	
	BNE fib_loop   ; if n != 0, restart loop
	
	MOV R0, R3
	
	BX LR

	ALIGN        ; make sure the end of this section is aligned
	END          ; end of file
		

