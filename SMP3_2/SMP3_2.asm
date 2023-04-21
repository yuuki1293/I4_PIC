	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"
			
	__CONFIG	_HS_OSC
			
TMP0	EQU	0CH		
TMP1	EQU	0DH

	ORG	0H
MAIN
	BSF	STATUS, RP0	
	CLRF	TRISB		
	MOVLW	01FH		
	MOVWF	TRISA		
	BCF	STATUS,	RP0		
	CLRF	PORTB		
LOOP
	MOVF	PORTA,	W
	ANDLW	B'00000001'
	MOVWF	TMP0
	MOVF	PORTA,	W
	ANDLW	B'00000010'
	MOVWF	TMP1
	BCF		STATUS,	C
	RRF		TMP1,	W
	IORWF	TMP0,	W
	MOVWF	PORTB
	GOTO	LOOP
	END