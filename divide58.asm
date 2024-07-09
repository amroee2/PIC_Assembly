PROCESSOR 16F877A
INCLUDE "P16F877A.INC"

__CONFIG 0x3731

; Variables
Count EQU 0x20     ; Temporary register for counting overflows
Char EQU 0x25
Blinker EQU 0x30

prevCarry equ 0x23
res1 equ 0x21
res2 equ 0x22

L EQU  0x26
H EQU 0x27
divl EQU 0x28
divh EQU 0x29


; The instructions should start from here
ORG 0x00
GOTO init

ORG 0x04
GOTO ISR

; The init for our program
init:


 ;   BANKSEL TRISD
  ;  CLRF TRISD
  ;  BANKSEL PORTD
    GOTO start

; Interrupt Service Routine
ISR:
    ; TASK
   ; INCF Char
    ; END TASK
    retfie

INCLUDE "LCDIS_PORTD.INC" ; IF U WANT TO USE LCD ON PORT D

; The main code for our program


start:
	call divide58
terminate:
	goto loop
divide58:
;    CALL xms
 ;   CALL xms
 	movlw 0xFF       ; Load high byte (sign-extended part for negative number)
    movwf divh   ; Move to high byte register

    movlw 0xC6       ; Load low byte (two's complement of 58)
    movwf divl    ; Move to low byte register

	movlw 0xAE
	;sublw 
	movwf L
	movlw 0x00
	movwf H

	movlw 00
	movwf Count
	

divide:

	movf L, W           ; Load low byte of current value into W
    addwf divl, W         ; Subtract the constant value (58)
    movwf L             ; Store the result back into LOW_REG
		movlw 0
		btfsc STATUS, C           ; Check Carry flag, skip if set
		movlw 1
		btfss STATUS, C
		call chneg
		
		btfsc STATUS, C           ; store the carry of the low register
		bsf prevCarry ,0
		btfss STATUS, C   ; Check if the Carry bit is clear
    	bcf prevCarry, 0  ; If Carry is clear, clear bit 0 of CARRY_VAR

		btfsc STATUS, Z           ; store the carry of the low register
		bsf prevCarry ,1
		btfss STATUS, Z   ; Check if the Carry bit is clear
    	bcf prevCarry, 1  ; If Carry is clear, clear bit 0 of CARRY_VAR

	addwf H ,W          ; Load high byte of current value into W
	movwf res1
    addwf divh, W         ; Subtract the constant value (58)
	movwf res2
    movwf H            ; Store the result back into HIGH_REG

			incf Count ,F
			btfss STATUS, Z   ; if zero chzero else divide 
    		goto divide 
			goto chzero
			;goto chneg
			
			

chzero:
	btfsc prevCarry, 1 ; if zero terminate else skip
	goto zero
	goto divide

chneg:	;if no carry terminate else skip 
	movf H, W
	btfsc STATUS , Z
	goto aboveHalf
;	goto terminate
	movlw 0
	RETURN
	

aboveHalf:
	movf L, W
	addlw 0x1D ; add 29 to w
	btfsc STATUS, Z
	goto zero
	btfsc STATUS, C
	incf Count, F
	goto terminate

goto terminate


zero:
	incf Count, F
	goto terminate
;	goto negative



loop:

    GOTO loop


END
