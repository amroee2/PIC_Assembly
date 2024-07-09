PROCESSOR 16F877A
INCLUDE "P16F877A.INC"

; Configuration bits
__CONFIG 0x3731

; Define constants
#define TRIGGER_PIN  RB0   ; Trigger pin connected to RB0
#define ECHO_PIN     RB1   ; Echo pin connected to RB1

; RAM variables
distance        equ 0x20  ; Variable to store distance
duration_high   equ 0x21  ; Variable to store high byte of duration
duration_low    equ 0x22  ; Variable to store low byte of duration
temp            equ 0x23  ; Temporary register for calculations
divisor         equ 0x24  ; Divisor for division routine
Char            equ 0x25
hundreds        equ 0x26  ; Hundreds place
tens            equ 0x27  ; Tens place
units           equ 0x28  ; Units place
counter         equ 0x29  ; Counter for division routine
quotient         equ 0x30
remainder         equ 0x30
Msd               equ 0x31
Lsd               equ 0x32 
L EQU  0x33
H EQU 0x34
divl EQU 0x35
divh EQU 0x36
Count EQU 0x37 

prevCarry equ 0x38
res1 equ 0x39
res2 equ 0x40
; Main program
ORG 0x00
GOTO init   ; Jump to main program


ORG 0x04
GOTO ISR

; Initialization routine
init:
    banksel TRISB       ; Select bank for TRISB
    movlw b'00000010'   ; Set RB1 as input (echo), others as output
    movwf TRISB         ; Configure PORTB
    banksel distance    ; Select bank for distance
    clrf distance       ; Clear distance variable
    clrf duration_high  ; Clear duration high byte
    clrf duration_low   ; Clear duration low byte
    
    ; Timer1 configuration
    banksel T1CON       ; Select bank for T1CON
    movlw b'00000000'   ; Timer1 on, prescaler 1:4 (Fosc/4)
    movwf T1CON
    
    BANKSEL TRISD
    CLRF TRISD
    BANKSEL PORTD
    GOTO main
    
ISR:

    retfie

; Main program routine

INCLUDE "LCDIS_PORTD.INC"
main:

    call xms
    call xms
    call inid

   
   
  
loop:
    ; Trigger pulse generation
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)        
    call delay_us_10         ; Wait for 10 µs
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    
    ; Wait for echo pulse to start
wait_echo:
    btfss PORTB, ECHO_PIN    ; Wait for RB1 to go high
    goto wait_echo
    
    ; Measure echo pulse duration
    banksel TMR1L            ; Select bank for TMR1 low byte
    clrf TMR1L               ; Clear TMR1 low byte
    clrf TMR1H               ; Clear TMR1 high byte
    bsf T1CON, TMR1ON        ; Turn on Timer1
    
wait_echo_high:
    btfsc PORTB, ECHO_PIN    ; Wait for RB1 to go low
    goto wait_echo_high
    
    bcf T1CON, TMR1ON    ; Turn off Timer1
    movf TMR1H, W        ; Read Timer1 high byte
    movwf duration_high  ; Store high byte of duration
    movf TMR1L, W        ; Read Timer1 low byte
    movwf duration_low   ; Store low byte of duration

   movf  TMR1L,W
   movwf  L
   movf TMR1H, W  
   movwf  H
   goto divide58
   terminate:



; Convert high byte to ASCII and display
;movf duration_high, W
;call bin_to_ascii
;call display_digits

        ; Call LCD send routine

; Move to the next position on LCD (depends on your LCD configuration)


; Convert low byte to ASCII and display
;movlw TMR1L
;sublw 3A
;sublw 3A
;sublw 3A
;call bin_to_ascii
;call display_digits 
;bsf PORTD, RS     ; Set RS for data
;call send 

; Convert binary to BCD ...................................


;MOVLW   b'00000101'   ; Load literal 00000101 (binary 5)
;MOVWF   TMR1L         ; Move WREG to TMR1L to set TMR1L to 5 in binary
outres	MOVF  Count ,W	; load result
	MOVWF	Lsd		; into low digit store
	CLRF	Msd		; high digit = 0
	BSF	STATUS,C	; set C flag
	MOVLW	D'10'		; load 10

again	SUBWF	Lsd		; sub 10 from result
	INCF	Msd		; inc high digit
	BTFSC	STATUS,C	; check if negative
	GOTO	again		; no, keep going
	ADDWF	Lsd		; yes, add 10 back 
	DECF	Msd		; inc high digit


; display 2 digit BCD result ..............................

	MOVF	Msd,W		; load high digit result
		; yes, dont display Msd

	ADDLW	030		; convert to ASCII
	BSF	Select,RS	; Select data mode
	CALL	send		; and send Msd

lowd	MOVF	Lsd,W		; load low digit result
    ADDLW	030		; convert to ASCII
	BSF	Select,RS	; Select data mode
	CALL	send		; and send Msd

			; scan for clear key
    
    
   ; movf temp, W         ; Move the calculated distance
    ;movwf distance       ; Store calculated distance in variable
    
    ; Your further processing here, e.g., sending distance over UART or displaying on LCD
    
    goto loop            ; Repeat loop indefinitely

; Delay function for 10 µs delay
delay_us_10:
    nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
return
divide58:
;    CALL xms
 ;   CALL xms
 	movlw 0xFF       ; Load high byte (sign-extended part for negative number)
    movwf divh   ; Move to high byte register

    movlw 0xC6       ; Load low byte (two's complement of 58)
    movwf divl    ; Move to low byte register
    ; write the parameters

	;movlw 0xAE
	;sublw 
	;movwf L
	;movlw 0x00
	;movwf H

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
		goto chneg
back:
		
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
	goto back
	

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


end
