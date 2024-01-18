    LIST P=PIC16F819
    #INCLUDE <P16F819.INC>

    __CONFIG    _HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_ON & _MCLR_ON & _LVP_OFF

;uart
CNT1        EQU 0EH
CNTB        EQU 0FH
IN          EQU 012H
ADL         EQU 013H
ADH         EQU 014H

;ad
CNT         EQU 020H

    ORG     0H

MAIN
    BSF     STATUS, RP0
    MOVLW   b'000000001'
    MOVWF   TRISA
    CLRF    TRISB
    MOVLW   b'10001110'
    MOVWF   ADCON1
    BCF     STATUS, RP0
    MOVLW   b'10000001'
    MOVWF   ADCON0
    CLRF    PORTA
    CLRF    PORTB

ADSTART
    CALL    TIME20U
    BSF     ADCON0, GO
ADLOOP
    BTFSC   ADCON0, GO
    GOTO    ADLOOP

    BSF     STATUS, RP0
    MOVF    ADRESL, W
    BCF     STATUS, RP0
    MOVWF   ADL
    MOVF    ADRESH, W
    MOVWF   ADH

;Tx begin
;b01000000 開始信号送信
    MOVLW   b'00010000'
    CALL    CSEND
;3:0ビット送信
    MOVF    ADL, W
    ANDLW   b'00001111'
    CALL    CSEND
;7:4ビット送信
    SWAPF   ADL, W
    ANDLW   b'00001111'
    CALL    CSEND
;9:8ビット送信
    MOVF    ADH, W
    CALL    CSEND
;b10000000 終了信号送信
    MOVLW   b'00100000'
    CALL    CSEND

;Tx end

    GOTO    ADSTART

TIME20U
    MOVLW   020H
    MOVWF   CNT
    NOP
LOOP
    DECFSZ  CNT, F
    GOTO    LOOP
    RETURN

CSEND
    MOVWF   IN
    MOVLW   08H
    MOVWF   CNTB
    BCF     PORTA, 4
    CALL    TIME104

CSENDLP
    BTFSC   IN, 0
    BSF     PORTA, 4
    BTFSS   IN, 0
    BCF     PORTA, 4
    CALL    TIME104
    RRF     IN, F
    DECFSZ  CNTB, F
    GOTO    CSENDLP
    BSF     PORTA, 4
    CALL    TIME104
    RETURN

TIME104
    MOVLW   082H
    MOVWF   CNT1
LOOP104
    NOP
    DECFSZ  CNT1, F
    GOTO    LOOP104
    RETURN

    END 