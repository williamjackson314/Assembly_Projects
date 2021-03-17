;****************** main.s ***************
; CPE287 Lab 1
; James Lumpp
; 8/28/2018
;*****************************************

;*****************************************
; Functions "IMPORTed" from elsewhere
;*****************************************

	IMPORT   PortF_Init
    IMPORT   blue_led_on
	IMPORT   blue_led_off
    IMPORT   red_led_on
	IMPORT   red_led_off
	IMPORT   green_led_on
	IMPORT   green_led_off
			
;*****************************************			
; These directives tell the assembler what type of code to expect
;*****************************************

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
    EXPORT  Start
		
;*******************************************
; No need to worry about anything above this point yet
;*******************************************


; Set of imported functions (these pre-assembled functions come 
; from CPE287Lib1.lib which is provided for you in the zip file):
; 	PortF_init:   to initialize GPIO port F
; 	blue_led_on:  to turn blue LED on
;	blue_led_off: to turn blue LED off
; 	red_led_on
; 	red_led_off
; 	green_led_on
; 	green_led_off

; By manipulating the sequence of funtion calls, you can generate 
; different light patterns without needing to know how the 
; functions XXX_led_on and XXX_led_off  work

FIRST			EQU 4
SECOND 			EQU 3
THIRD 			EQU 7

;---------------redled2----------------

redled2
	PUSH {R4}			; push R4 to stack, to preserve its initial state
	PUSH {LR}			; push link register to stack to preserve it
	LDR R4, =FIRST
	
redled_loop
	
	BL  red_led_on	
	BL  delay
	
	BL  red_led_off
	BL  delay
	
	SUBS R4, R4, #1 		; decrease count by one
	BNE redled_loop		; if count not zero, repeat loop
	
	POP {LR}			; restore link register
	POP {R4}			; restore R4
	
	BX LR



;---------------greenled8--------------

greenled8
	PUSH {R4}			; push R4 to stack, to preserve its initial state
	PUSH {LR}			; push link register to stack to preserve it
	LDR R4, =SECOND

greenled_loop

	BL  green_led_on
	BL  delay
	
	BL  green_led_off
	BL  delay
	
	SUBS R4, R4, #1
	BNE greenled_loop
	
	POP {LR}
	POP {R4}
	
	BX LR
	
	
;---------------blueled7----------------

blueled7
	PUSH {R4}			; push R4 to stack, to preserve its initial state
	PUSH {LR}			; push link register to stack to preserve it
	LDR R4, =THIRD
	
blueled_loop

    BL  blue_led_on   ; BL = "Branch and Link" used to call functions
    BL  delay         ; call delay function (below)

	BL  blue_led_off  ; call function to turn blue LED off
    BL  delay

	SUBS R4, R4, #1
	BNE blueled_loop
	
	POP {LR}
	POP {R4}
	
	BX LR

;------------ main function ------------

Start
    BL  PortF_Init  ; configure the port input and output pins of Port F for the LEDs

loop	
    
	BL redled2
	BL greenled8
	BL blueled7

	B   loop     ; B = "Unconditional Branch" Branch back to begining of loop

;------------delay------------
; Software delay function, which delays about 3*count clock cycles.
; Input:  R0 (contains "count" of the number of times to run the delay loop)
; Output: none
; Side Effect: time delay 
ONESEC             EQU 5333333      ; approximately 1s delay at ~16 MHz clock
QUARTERSEC         EQU 1333333      ; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC           EQU 1066666      ; approximately 0.2s delay at ~16 MHz clock
	
delay
	LDR R0, =QUARTERSEC
delay_loop
    SUBS R0, R0, #1                 ; R0 = R0 - 1 (count = count - 1)
    BNE delay_loop                  ; if count (R0) != 0, skip to 'delay'
    BX  LR                          ; return
	
	ALIGN
	END
