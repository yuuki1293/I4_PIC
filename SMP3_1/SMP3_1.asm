	list P=PIC16F84A
	include "P16F84A.inc"

	__config _HS_OSC

	org 0H
MAIN
	bsf STATUS, RP0
	clrf TRISB
	movlw 01FH
	movwf TRISA
	bcf STATUS, RP0
	clrf PORTB
LOOP
	movf PORTA, W
	movwf PORTB
	goto LOOP
	end