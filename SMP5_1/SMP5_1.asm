; C418 - Mellohi
; BPM = 90
; 4分音符 667ms
; 500 166 667 667
	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"

CALL_ MACRO CPRE, CMAIN
	MOVLW	CPRE
	MOVWF	CNTPRE
	MOVLW	CMAIN
	MOVWF	CNTMAIN
	CALL	TIME_
	ENDM

	__CONFIG	_HS_OSC&_WDT_OFF

CBLOCK	0CH
CNT50U ;TIME50Uで使用される
CNT_ ;TIME_で使用される
CNTPRE	;TIME_でのPREループの数
CNTMAIN ;TIME_でのメインループの数
LENGTH ;音の長さ
ENDC

	ORG		0H

MAIN
	BSF		STATUS, RP0
	CLRF	TRISB
	BCF		STATUS, RP0
MAINLP
	CALL	SECTION1

TOGGLE
	MOVLW	b'00000001'
	XORWF	PORTB, F
	RETURN

;50us・250c(250c*0.2us)
TIME50U						
	MOVLW	052H		; 1c 52H = 82		
	MOVWF	CNT50U		; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
LOOP50U
	DECFSZ	CNT50U, F		; 1*(82-1)+2*1 = 83
	GOTO	LOOP50U		; 2*(82-2) = 160
	RETURN				; 2c

TIME_
	MOVF	CNTPRE, W
	MOVWF	CNT_
LOOP_PRE
	DECFSZ	CNT_, F
	GOTO	LOOP_PRE

	MOVF	CNTMAIN, W
	MOVWF	CNT_
LOOP_
	CALL	TIME50U
	DECFSZ	CNT_, F
	GOTO	LOOP_
	RETURN

TIMED4
	CALL	TIMED5
	CALL	TIMED5
	RETURN

TIMEE4
	CALL	TIMEE5
	CALL	TIMEE5
	RETURN

TIMEFS4
	CALL	TIMEFS5
	CALL	TIMEFS5
	RETURN

TIMEG4
	CALL	TIMEG5
	CALL	TIMEG5
	RETURN

TIMEGS4
	CALL	TIMEGS5
	CALL	TIMEGS5
	RETURN

TIMEA4
	CALL	TIMEA5
	CALL	TIMEA5
	RETURN

;5362
;6 + 5356
TIMEAS4
	CALL_	1H, 15H
	RETURN

;5061c
;215 + 4846
TIMEB4
	CALL_	47H, 13H
	RETURN

;4777c
;186 + 4591
TIMEC5
	CALL_	3DH, 12H
	RETURN

;4509c
;173 + 4336
TIMECS5
	CALL_	39H, 11H
	RETURN

;4256c
;175 + 4081
TIMED5
	CALL_	3AH, 10H
	RETURN

;4017c
;191 + 3826
TIMEDS5
	CALL_	3FH, FH
	RETURN

;3792c
;221 + 3571
TIMEE5
	CALL_	49H, EH
	RETURN

;3579c
;8 + 3571
TIMEF5
	CALL_	2H, EH
	RETURN

;3378
;62 + 3316
TIMEFS5
	CALL_	14H, DH
	RETURN

;3188c
;127 + 3061
TIMEG5
	CALL_	2AH, CH
	RETURN

;3009c
;203 + 2806
TIMEGS5
	CALL_	43H, BH
	RETURN

;2840c
;34 + 2806
TIMEA5
	CALL_	BH, BH
	RETURN

SECTION1
	MOVLW	

	END