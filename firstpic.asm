PROCESSOR 16F877A
INCLUDE "P16F877A.INC"

__CONFIG 0x3731

; Variables
Count EQU 0x20     ; Temporary register for counting overflows
Char EQU 0x25
Blinker EQU 0x30
; The instructions should start from here
ORG 0x00
GOTO init

ORG 0x04
GOTO ISR

; The init for our program
init:
;	BANKSEL INTCON 
;	BSF INTCON, GIE
;	BSF INTCON, TMR0IE 
	
;	BANKSEL OPTION_REG
;	MOVLW b'00000000'
;	MOVWF OPTION_REG

	

	BANKSEL OPTION_REG
    MOVLW b'00000111'  ; Prescaler 1:256 assigned to Timer0
    MOVWF OPTION_REG

    BANKSEL TMR0
    CLRF TMR0          ; Clear Timer0 register
	

    BANKSEL TRISD
    CLRF TRISD
    BANKSEL PORTD
    GOTO start

; Interrupt Service Routine
ISR:
    ; TASK
    INCF Char
    ; END TASK
    retfie

INCLUDE "LCDIS_PORTD.INC" ; IF U WANT TO USE LCD ON PORT D

; The main code for our program
start:
    CALL xms
    CALL xms
	
    CALL inid
	CALL blink
loop:


    GOTO loop





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



END
