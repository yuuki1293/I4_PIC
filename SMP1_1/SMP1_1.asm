	list P=PIC16F84A
	include	"P16F84A.inc"
	
	__config	_HS_OSC
	
	org 0H
main
	bsf	STATUS, RP0
	clrf TRISB
	bcf	STATUS, RP0
	clrf PORTB
	bsf PORTB, 0

	end