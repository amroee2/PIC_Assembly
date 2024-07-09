; Include the PIC16F877A header file
    INCLUDE <p16f877a.inc>

; Configuration bits
   __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _XT_OSC

; Declare variables
    CBLOCK 0x20
        v1
        v2
        v3
        v4
        temp
    ENDC

; Initialize variables to 0
    ORG 0x00
    CLRF v1
    CLRF v2
    CLRF v3
    CLRF v4

; Hardcoded input values in binary
    MOVLW b'00001010' ; 10 in decimal
    CALL AddValue
    MOVLW b'00101100' ; 44 in decimal
    CALL AddValue
    MOVLW b'01100011' ; 99 in decimal
    CALL AddValue
    MOVLW b'10111111' ; 63 in decimal
    CALL AddValue
    MOVLW b'00000110' ; 6 in decimal
    CALL AddValue
    MOVLW b'00000011' ; 3 in decimal
    CALL AddValue
here:    GOTO here 

; AddValue subroutine
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

    END
