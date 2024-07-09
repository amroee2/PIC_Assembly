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
Blinker EQU 0x38

prevCarry equ 0x39
res1 equ 0x40
res2 equ 0x41
v1   equ 0x42
v2	 equ 0x43		
v3   equ 0x44
v4   equ 0x45
Hsd   EQU 0x46
printer equ 0x47



; Main program
ORG 0x00
    
GOTO init   ; Jump to main program


ORG 0x04
GOTO ISR

; Initialization routine
init:
    bsf STATUS, RP0   ; Select Bank 1
    movlw b'00000000' ; Set all PORTC pins as output
    movwf TRISC
    bcf STATUS, RP0   ; Select Bank 0


	BANKSEL OPTION_REG
    MOVLW b'00000111'  ; Prescaler 1:256 assigned to Timer0
    MOVWF OPTION_REG

    BANKSEL TMR0
    CLRF TMR0          ; Clear Timer0 register

	
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

	BANKSEL PORTD
    bcf PORTC, 3
    bcf PORTC, 4
    
    BANKSEL TRISD
    CLRF TRISD
    BANKSEL PORTD
	CALL blink
    GOTO main
    
ISR:

    retfie

; Main program routine

INCLUDE "LCDIS_PORTD.INC"
main:
    CLRF v1
    CLRF v2
    CLRF v3
    CLRF v4
	CLRF printer
    call inid
	CALL blink

   
   
  
loop:
    ; Trigger pulse generation

    bcf PORTC, 0
    bcf PORTC, 1
    bcf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bcf PORTC, 0
    bcf PORTC, 1
    bcf PORTC, 2
	call wait_echo

    bsf PORTC, 0
    bcf PORTC, 1
    bcf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bsf PORTC, 0
    bcf PORTC, 1
    bcf PORTC, 2
	call wait_echo

    bcf PORTC, 0
    bsf PORTC, 1
    bcf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bcf PORTC, 0
    bsf PORTC, 1
    bcf PORTC, 2
	call wait_echo

    bsf PORTC, 0
    bsf PORTC, 1
    bcf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bsf PORTC, 0
    bsf PORTC, 1
    bcf PORTC, 2
	call wait_echo

    bcf PORTC, 0
    bcf PORTC, 1
    bsf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bcf PORTC, 0
    bcf PORTC, 1
    bsf PORTC, 2
	call wait_echo

    bsf PORTC, 0
    bcf PORTC, 1
    bsf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bsf PORTC, 0
    bcf PORTC, 1
    bsf PORTC, 2
	call wait_echo

    bcf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bcf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
	call wait_echo

    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2

    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (trigger low)
    nop
    nop
    bsf PORTB, TRIGGER_PIN   ; Set RB0 high (trigger pulse)  
    bcf PORTC, 0
    bcf PORTC, 1
    bcf PORTC, 2
   
    call delay_us_10         ; Wait for 10 �s
    bcf PORTB, TRIGGER_PIN   ; Clear RB0 (end trigger pulse)
    bsf PORTC, 0
    bsf PORTC, 1
    bsf PORTC, 2
	call wait_echo

    BTFSS PORTC, 3 ; Test bit PORTC,3, skip if set
    GOTO CHECK_C4
    GOTO NEXT_STATE



	goto loop

    ; Wait for echo pulse to start
CHECK_C4:
    BTFSS PORTC, 4 ; Test bit PORTC,4, skip if set
    GOTO STATE_00
    GOTO NEXT_STATE

STATE_00:
    ; Set PORTC to 01
    BSF PORTC, 3
    GOTO loop

NEXT_STATE:
    ; Check if PORTC,3 is 1 and PORTC,4 is 0 (01)
    BTFSC PORTC, 3 ; Test bit PORTC,3, skip if clear
    GOTO CHECK_C4_01
    GOTO NEXT_STATE_10

CHECK_C4_01:
    BTFSS PORTC, 4 ; Test bit PORTC,4, skip if set
    GOTO STATE_01
    GOTO loop

STATE_01:
    ; Set PORTC to 10
    BCF PORTC, 3
    BSF PORTC, 4
    GOTO loop

NEXT_STATE_10:
    ; Check if PORTC,3 is 0 and PORTC,4 is 1 (10)
    BTFSS PORTC, 3 ; Test bit PORTC,3, skip if set
    GOTO CHECK_C4_10
    GOTO loop

CHECK_C4_10:
    BTFSC PORTC, 4 ; Test bit PORTC,4, skip if clear
    GOTO STATE_10
    GOTO loop

STATE_10:
    ; Set PORTC to 00
    BCF PORTC, 3
    BCF PORTC, 4
    GOTO loop

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
   MOVF  Count, W 
   call  AddValue
   ;MOVF  v1, W
   ;call outres
   ;call delay_0_5s
   ;call delay_0_5s
   ; MOVF  v2, W
   ;call outres
   ;call delay_0_5s
   ;call delay_0_5s
    ;MOVF  v3, W
   ;call outres
   ;call delay_0_5s
   ;call delay_0_5s
    ;MOVF  v4, W
   ;call outres
   ;call delay_0_5s
   ;call delay_0_5s
   ;call nextTurn
   
   

; Convert binary to BCD ...................................
outres  MOVF  v1, W    ; load Count into W
        MOVWF Lsd         ; initially store Count in Lsd
        CLRF  Msd         ; clear tens place
        CLRF  Hsd         ; clear hundreds place

; Extract hundreds place
        MOVLW D'100'      ; load 100 into W
loop100 SUBWF Lsd, F      ; subtract 100 from Lsd
        BTFSS STATUS, C   ; if result is negative, exit loop
        GOTO done100      ; if negative, exit loop
        INCF  Hsd, F      ; increment hundreds place
        GOTO loop100      ; repeat for more hundreds
done100 ADDWF Lsd, F      ; add 100 back to Lsd if last subtraction was negative

; Extract tens place
        MOVLW D'10'       ; load 10 into W
loop10  SUBWF Lsd, F      ; subtract 10 from Lsd
        BTFSS STATUS, C   ; if result is negative, exit loop
        GOTO done10       ; if negative, exit loop
        INCF  Msd, F      ; increment tens place
        GOTO loop10       ; repeat for more tens
done10  ADDWF Lsd, F      ; add 10 back to Lsd if last subtraction was negative

; Display hundreds place
        MOVF  Hsd, W      ; load hundreds digit result
		BTFSC	STATUS,Z	; check if Z
	    GOTO	mid
        ADDLW D'48'       ; convert to ASCII ('0' is ASCII 30h or 48 decimal)
        BSF   Select, RS  ; select data mode
        CALL  send        ; send hundreds digit

; Display tens place
mid:
        MOVF  Msd, W      ; load tens digit result
        ADDLW D'48'       ; convert to ASCII
        BSF   Select, RS  ; select data mode
        CALL  send        ; send tens digit

; Display units place
        MOVF  Lsd, W      ; load units digit result
        ADDLW D'48'       ; convert to ASCII
        BSF   Select, RS  ; select data mode
        CALL  send        ; send units digit




;nextTurn:

    RETURN           ; Repeat loop indefinitely

; Delay function for 10 �s delay
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



blink:
	MOVLW 0x03         ; Number of blinks (3)
    MOVWF Blinker        ; Load Count with the number of blinks
	blink_loop:
		CALL display_text   ; Display the text
	    CALL delay_0_5s        ; Delay for some time
	    CALL clear_lcd      ; Clear the LCD
	    CALL delay_0_5s          ; Delay for some time
		DECFSZ Blinker, f    ; Decrement the overflow count
   		GOTO blink_loop    ; Repeat until Count reaches zero
	RETURN

; Subroutine to display the text
display_text:
    MOVLW 0x80 
    MOVWF Char
    BCF Select, RS
    CALL send



    ; Write "Welcome to"
    MOVLW 'W'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'e'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'l'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'c'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'o'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'm'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'e'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW ' '
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 't'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'o'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 0xC0
    MOVWF Char
    BCF Select, RS
    CALL send

    ; Write "SFR04 Modules"
    MOVLW 'S'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'F'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'R'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW '0'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW '4'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW ' '
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'M'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'o'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'd'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'u'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'l'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 'e'
    MOVWF Char
    BSF Select, RS
    CALL send

    MOVLW 's'
    MOVWF Char
    BSF Select, RS
    CALL send

    RETURN

; Subroutine to clear the LCD
clear_lcd:
    MOVLW 0x01         ; Clear display command
    MOVWF Char
    BCF Select, RS     ; Command mode
    CALL send
    RETURN

; Subroutine to generate a 0.5-second delay
delay_0_5s:
    MOVLW 0x08         ; Number of overflows (8)
    MOVWF Count        ; Load Count with the number of overflows

delay_loop:
    CLRF TMR0          ; Clear Timer0 register
    BCF INTCON, T0IF   ; Clear Timer0 overflow flag

wait_for_overflow:
    BTFSS INTCON, T0IF ; Check if Timer0 overflow flag is set
    GOTO wait_for_overflow ; Wait here until Timer0 overflows

    DECFSZ Count, f    ; Decrement the overflow count
    GOTO delay_loop    ; Repeat until Count reaches zero

    RETURN

delay:
    movlw d'250'
    movwf 0x21
d1:
    movlw d'250'
    movwf 0x22
d2:
    nop
    nop
    decfsz 0x22, f
    goto d2
    decfsz 0x21, f
    goto d1
    return

AddValue:
    MOVWF temp

    ; Compare with v1
    MOVF v1, W
    SUBWF temp, W
    BTFSS STATUS, C
    GOTO CheckV2
    ; Shift values down
    MOVF v3, W
    MOVWF v4
    MOVF v2, W
    MOVWF v3
    MOVF v1, W
    MOVWF v2
    MOVF temp, W
    MOVWF v1
    RETURN

CheckV2:
    MOVF v2, W
    SUBWF temp, W
    BTFSS STATUS, C
    GOTO CheckV3
    ; Shift values down
    MOVF v3, W
    MOVWF v4
    MOVF v2, W
    MOVWF v3
    MOVF temp, W
    MOVWF v2
    RETURN

CheckV3:
    MOVF v3, W
    SUBWF temp, W
    BTFSS STATUS, C
    GOTO CheckV4
    ; Shift value down
    MOVF v3, W
    MOVWF v4
    MOVF temp, W
    MOVWF v3
    RETURN

CheckV4:
    MOVF v4, W
    SUBWF temp, W
    BTFSS STATUS, C
    RETURN
    ; Store in v4 if larger than current v4
    MOVF temp, W
    MOVWF v4
    RETURN


end
