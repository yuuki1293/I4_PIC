	list P=PIC16F84A
	include	"P16F84A.inc"
	
	__config	_HS_OSC
	
	org 0H
main
	bsf	STATUS, RP0
	clrf TRISB
	bcf	STATUS, RP0
	bsf PORTB, 0
	bsf PORTB, 1
	bsf PORTB, 2
	bsf PORTB, 3
	bsf PORTB, 4
	bsf PORTB, 5
	bsf PORTB, 6
	bsf PORTB, 7

	end