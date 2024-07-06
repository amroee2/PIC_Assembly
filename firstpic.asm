
PROCESSOR 16F877A
INCLUDE "P16F877A.INC"	


__CONFIG 0x3731



Char EQU 0x25
;Char2 EQU 0x26







; The instructions should start from here
ORG 0x00
GOTO init


ORG 0x04
GOTO ISR


; The init for our program
init:




BANKSEL TRISD
CLRF TRISD

BANKSEL PORTD













GOTO start


; When intruput happend the program will enter here
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


loop:

CALL xms
CALL xms

CALL intro

CALL xms
CALL xms



GOTO loop






intro:

movlw 0x80 


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

MOVLW 'S'
MOVWF Char
BSF Select, RS
CALL send


MOVLW 'R'
MOVWF Char
BSF Select, RS
CALL send


MOVLW 'F'
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


MOVLW 0x80
MOVWF Char
BCF Select, RS
CALL send


RETURN



END
