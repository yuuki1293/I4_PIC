; RA0 - 7セグ 左A
; RA1 - 7セグ 左B
; RA2 - 7セグ 左C
; RA3 - 7セグ 左D
; RB0 - 7セグ 右A
; RB1 - 7セグ 右B
; RB2 - 7セグ 右C
; RB3 - 7セグ 右D
; RB4 - PSW1
; RB5 - PSW2

	LIST P=PIC16F84A
	#INCLUDE <P16F84A.INC>

	__CONFIG _HS_OSC &_CP_OFF &_WDT_OFF &_PWRTE_ON

XORLF	MACRO	FILE, LIT
		MOVLW	LIT
		XORWF	FILE, W
		ENDM

JZ		MACRO	LABEL
		BTFSC	STATUS, 2
		GOTO	LABEL
		ENDM

CBLOCK	0CH
SEGL	; 0~9
SEGR	; 0~9
; 0 -> 動作状態（両方）
; 1 -> 動作状態（右）
; 2 -> 待機状態
LOCKFLG
W_TEMP
STATUS_TEMP
CNT1
CNT2
CNT3
CNT4
ENDC

	ORG		0H
	GOTO	MAIN

	ORG		04H

; PUSH
	MOVWF	W_TEMP
	MOVF	STATUS, W
	MOVWF	STATUS_TEMP

	BTFSC	PORTB, 4
	GOTO	PSW1
	BTFSC	PORTB, 5
	GOTO	PSW2
	GOTO	_POP

; ストップボタンが押された場合の処理
PSW1
	XORLF	LOCKFLG, 2
	JZ		_POP

	CALL	ROTATE_LOCK

	XORLF	LOCKFLG, 0
	JZ		TO1
	XORLF	LOCKFLG, 1
	JZ		TO2
TO1
	GOTO	_POP

TO2
	CALL	JUDGE

	GOTO	_POP

; スタートボタンが押された場合の処理
PSW2
	XORLF	LOCKFLG, 2
	BTFSS	STATUS, 2
	GOTO	_POP

	CALL	ROTATE_LOCK

	CALL	PLAY_FANFARE

_POP
	MOVF	STATUS_TEMP, W
	MOVWF	STATUS
	SWAPF	W_TEMP, W

	BCF		INTCON, RBIF
	RETFIE

; LOCKFLGを次の状態にする。（0->1->2->0）
ROTATE_LOCK
	INCF	LOCKFLG, F
	BTFS	LOCKFLG, 1
	XORLF	LOCKFLG, 3H
	BTFSC	STATUS, 2
	CLRF	LOCKFLG
	RETURN

; 7セグの両辺が等しいか調べて、その後の処理を実行する。
JUDGE
	MOVWF	SEGL
	XORWF	SEGR, W
	JZ		SUCCESS
FAILURE
	CALL	PLAY_FAIRURE
	RETURN
SUCCESS
	CALL	PLAY_SUCCESS
	CALL	FLASH
	RETURN

; 7セグを点滅させる。
FLASH
	MOVLW	5H
	MOVWF	CNT4
FLASHLOOP
	CLRF	PORTA
	CLRF	PORTB
	CALL	TIME125M
	CALL	UPDATESEG
	CALL	TIME125M
	DECFSZ	CNT4, F
	GOTO	FLASHLOOP

	RETURN

; MAINサブルーチン
MAIN
	; 割り込み設定
	BCF		INTCON, GIE
	BSF		INTCON, RBIE

	; ピン入出力モード設定
	BSF		STATUS, RP0
	CLRF	TRISA
	MOVLW	B'00110000'
	MOVWF	TRISB
	BCF		STATUS, RP0

	; レジスタの初期化
	CLRF	PORTA
	CLRF	PORTB
	CLRF	SEGL
	CLRF	SEGR
	CLRF	LOCKFLG

	; 割り込み設定
	BSF		INTCON, GIE
	BCF		INTCON, INTF
MAINLP
	CALL	NEXTSEG
	CALL	UPDATESEG
	CALL	TIME125M
	GOTO	MAINLP

; LOCKFLGについて
; 0 -> 左右をインクリメントする。
; 1 -> 右のみをインクリメントする。
; _ -> 何もしない。
NEXTSEG
	XORLF	LOCKFLG, 0H
	JZ		INCLEFT
	XORLF	LOCKFLG, 1H
	JZ		INCRIGHT
	RETURN
; SEGLをインクリメントする。
INCLEFT
	INCF	SEGL, F
	XORLF	LOCKFLG, AH
	BTFSC	STATUS, 2
	CLRF	SEGL
; SEGRをインクリメントする。
INCRIGHT
	INCF	SEGR, F
	XORLF	LOCKFLG, AH
	BTFSC	STATUS, 2
	CLRF	SEGL

	RETURN

; SEGL、SEGRに基づいて7セグへの出力を更新する。
UPDATESEG
	MOVF	SEGL, W
	MOVWF	PORTA

	MOVF	SEGR, W
	MOVWF	PORTB

	RETURN

;50us(250c*0.2us)
TIME50U						
	MOVLW	    052H	; 1c 52H = 82		
	MOVWF	    CNT1	; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
LOOP1
	DECFSZ		CNT1, F	; 1*(82-1)+2*1 = 83
	GOTO		LOOP1	; 2*(82-2) = 160
	RETURN				; 2c

;5ms(25000*0.2us)	
TIME5M
	MOVLW	062H 		; 1c 62H = 98
	MOVWF 	CNT2		; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
LOOP2
	CALL	TIME50U		; (2+250)*98 = 24696
	DECFSZ	CNT2, F		; 1*(98-1)+2*1 = 99
	GOTO	LOOP2		; 2*(98-1) = 194
	RETURN				; 2c

;125ms(25*5ms)
TIME125M
	MOVLW	19H			; 19H = 25
	MOVWF	CNT3
LOOP3
	CALL	TIME5M
	DECFSZ	CNT3, F
	GOTO 	LOOP3
	RETURN

; ファンファーレを鳴らす。
PLAY_FANFARE
	RETURN

; 失敗した音を鳴らす。
PLAY_FAIRURE
	RETURN

; 成功した音を鳴らす。
PLAY_SUCCESS
	RETURN

	END