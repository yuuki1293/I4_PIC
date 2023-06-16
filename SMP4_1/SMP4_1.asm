	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"
		
	__CONFIG    _HS_OSC&_WDT_OFF
		
CNT1	EQU	    0CH
CNT2	EQU	    0DH
CNT3	EQU	    0EH

	ORG	    0H

MAIN	
	BSF	    STATUS , RP0
	CLRF	    TRISB
	BCF	    STATUS , RP0
MAINLP	
	CLRF	    PORTB
	CALL	    TIME05
	MOVLW	    0FFH
	MOVWF	    PORTB
	CALL	    TIME05
	GOTO	    MAINLP
	

TIME100U						
	MOVLW	    0A5H			
	MOVWF	    CNT1			
	NOP						
	NOP						
LOOP1
	DECFSZ	    CNT1,F			
	GOTO	    LOOP1			
	RETURN					
		

TIME10M
	MOVLW	    063H			
	MOVWF	    CNT2			
	NOP						
	NOP		
LOOP2
	CALL	    TIME100U
	DECFSZ	    CNT2,F	
	GOTO	    LOOP2			
	RETURN					
	
TIME05
	MOVLW	    032H			
	MOVWF	    CNT3
LOOP3
	CALL	    TIME10M
	DECFSZ	    CNT3,F
	GOTO	    LOOP3
	RETURN
		
	END
