$NOMOD51	 ;to suppress the pre-defined addresses by keil
$include (C8051F020.INC)		; to declare the device peripherals	with it's addresses
ORG 0H					   ; to start writing the code from the base 0


;diable the watch dog
MOV WDTCN,#11011110B ;0DEH
MOV WDTCN,#10101101B ;0ADH

; config of clock
MOV OSCICN , #14H ; 2MH clock
;config cross bar
MOV XBR0 , #00H
MOV XBR1 , #00H
MOV XBR2 , #040H  ; Cross bar enabled , weak Pull-up enabled 

;config,setup
MOV P1MDOUT, #0FFh
MOV P3MDOUT, #0FFh
MOV P0MDOUT, #00h



;loop

START:
	MOV R3,#4
	MOV R6,#11
	
	MOV DPTR, #400h	
	MOV P3, #3FH ;0
	MOV P1, #4FH ;3
	MOV 50H,#5 ;address for freq button
	MOV 55H,#00H ; index for count1
	MOV 60H,#06H ; index for count 2
	MOV 65H,#01H ; address for red and blue
	MOV 70H,#02H ; address for red and blue
	MOV R4,#06H  ; register for 
	MOV R5,#4FH
	MOV 85H,#04
	MOV P2, 65H
	ACALL DELAY

MAIN: 
	;MOV P1, #3FH ;0
	ACALL BUTTON
	DJNZ R3, COUNT
	MOV 60H,R4
	MOV R3,85H
	;MOV P1, R5 ;3
	ACALL DELAY
	MOV 75H, 65H
	MOV 65H , 70H
	MOV 70H ,75H
	MOV P2,65H
	AJMP MAIN
	
COUNT:
	INC 60H
	MOV A,60H
	MOVC A,@A+DPTR
	MOV P1,A
	CONT:
		DJNZ R6, COUNT2
	MOV R6,#11
	MOV 55H,#00H
	AJMP MAIN
		


COUNT2:
	ACALL BUTTON
	MOV A,55H
	MOVC A,@A+DPTR
	MOV P3,A
	ACALL DELAY
	INC 55H
	AJMP CONT
BUTTON:
	MOV A, P0
	ANL A,#00000001B
	JZ A1
	MOV A, P0
	ANL A,#00000010B
	JZ A2
	MOV A, P0
	ANL A,#00000100B
	JZ A3

	MOV A, P0
	ANL A,#00001000B
	JZ B1
	MOV A, P0
	ANL A,#00010000B
	JZ B2
	MOV A, P0
	ANL A,#00100000B
	JZ B3
	RET
B1:
	DEC 60H
	ACALL DELAY
	INC R3
	ACALL DELAY
	DEC R4
	ACALL DELAY
	INC 85H
	AJMP BUTTON
B2:
	MOV 60H,#07H
	MOV R3,#3
	MOV R4,60H
	MOV 85H,#3
	MOV R5,#5BH
	AJMP BUTTON
B3:
	MOV 60H,#08H
	MOV R3,#2
	MOV R4,60H
	MOV 85H,#2
	MOV R5,#06H
	AJMP BUTTON
A1:
	MOV 50H,#1
	AJMP BUTTON
A2:
	MOV 50H,#3
	AJMP BUTTON
A3:
	MOV 50H,#5
	AJMP BUTTON


	

DELAY:
	MOV R2,50H
	LOOP3:MOV R1,#200
	ACALL BUTTON
	LOOP2:MOV R0,#198
	LOOP1:DJNZ R0,LOOP1
	DJNZ R1,LOOP2
	DJNZ R2,LOOP3
	RET

ORG 400H

DB 6FH, 7FH, 07H, 7DH, 6DH, 66H, 4FH, 5BH, 06H,3FH
;3FH, 06H , 5BH ,4FH,66H,6DH,7DH,07H,7FH,6FH

END