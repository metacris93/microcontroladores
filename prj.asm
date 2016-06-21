	LIST		p=16F887			
	INCLUDE 	P16F887.INC		
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC&_INTOSCIO	
	errorlevel	 -302

	CBLOCK
		aleatorio    ; contendra numeros entre 1 y 16
		contador     ; contador de retardos
		temporizador ; contador de interrupciones
		nivel
		dato 
	ENDC

	   org	0x00		     	; vector de reset
       goto	main			    ; salto a label "main"
       org	0x04       		    ; vector de interrupción  
       goto	interrupcion 		; salto a interrupción
       org	0x05  			    ; continuación de programa

;***************************************************************************
;****                          GENERAR_RANDOM                            ***
;***************************************************************************
generar_random
	movf  temporizador,w  ; cargo el valor del timer0 en W, para generar el numero aleatorio
	andlw 0x0F			  ; obtengo los 4 bits menos significativos que va a representar un numero entre 0 y 15, lo guarda en W
	movwf aleatorio
	;****** es igual a 15 *******
	movlw 0x0F ; 15
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector16
	goto $+1
	;****** es igual a 14 *******
	movlw 0x0E ; 14
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector15
	goto $+1
	;****** es igual a 13 *******
	movlw 0x0D ; 13
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector14
	goto $+1
	;****** es igual a 12 *******
	movlw 0x0C ; 12
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector13
	goto $+1
	;****** es igual a 11 *******
	movlw 0x0B ; 11
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector12
	goto $+1
	;****** es igual a 10 *******
	movlw 0x0A ; 10
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector11
	goto $+1
	;****** es igual a 9 *******
	movlw 0x09 ; 9
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector10
	goto $+1
	;****** es igual a 8 *******
	movlw 0x08 ; 8
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector9
	goto $+1
	;****** es igual a 7 *******
	movlw 0x07 ; 7
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector8
	goto $+1
	;****** es igual a 6 *******
	movlw 0x06 ; 6
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector7
	goto $+1
	;****** es igual a 5 *******
	movlw 0x05 ; 5
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector6
	goto $+1
	;****** es igual a 4 *******
	movlw 0x04 ; 4
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector5
	goto $+1
	;****** es igual a 3 *******
	movlw 0x03 ; 3
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector4
	goto $+1
	;****** es igual a 2 *******
	movlw 0x02 ; 2
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector3
	goto $+1
	;****** es igual a 1 *******
	movlw 0x01 ; 1
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector2
	goto $+1
	;****** es igual a 0 *******
	movlw 0x00 ; 0
	xorwf aleatorio,W
	btfsc STATUS,2
	call sector1
	goto finalizando_random  

;***************************************************************************
;****                        FINALIZANDO_RANDOM                          ***
;***************************************************************************
finalizando_random
	bcf INTCON,RBIF
	goto fin_interrupcion	
	
;***************************************************************************
;****                         INTERRUPCION                               ***
;***************************************************************************
interrupcion
	btfss  INTCON,RBIE	
	goto   interrupcion_timer0
	goto   interrupciom_portb

;***************************************************************************
;****                        INTERRUPCION_PORTB                          ***
;***************************************************************************	
interrupciom_portb
	banksel  PORTB
	btfsc    PORTB,0	
	goto  generar_random

	btfsc    PORTB,1
	goto  generar_random

	btfsc    PORTB,2
	goto  generar_random

	btfsc    PORTB,3
	goto  generar_random
	
	btfsc    PORTB,4
	goto  generar_random

	btfsc    PORTB,5
	goto  generar_random

	btfsc    PORTB,6
	goto  generar_random

	btfsc    PORTB,7	
	goto  generar_random

;**************************************************************************
;****                     INTERRUPCION_TIMER0                           ***
;**************************************************************************
interrupcion_timer0
	decfsz 	    temporizador,f	;Decrementa el contador del timer0
    goto		Seguir		    ;No, todavía
	;movf		unidades,w  	;Ya ocurrieron 100 int de 10ms(1000ms)
	;call		TABLA
	;movwf		uni_cod
	;movf 		uni_cod,w
	;movwf		PORTB
	;INCF 		unidades,f
	;movlw		.10
	;subwf		unidades,w
	;btfss		STATUS,2
	;goto		contando
	;clrf		unidades

contando
 	;movlw 		.150
    ;movwf	 	contador   	;Repone el contador con 100 

Seguir    
	;movlw 		.217	;"~.39" es el complemento a 256
				;equivale a ".217"		
    ;movwf 		TMR0      	;Repone el TMR0 con 217
	;bcf		    INTCON,T0IF	;Repone flag del TMR0
    RETFIE			;Retorno de interrupción

	
;***************************************************************************
;****                                MAIN                                ***
;***************************************************************************
main
	BANKSEL TRISA
	MOVLW	B'11111111'
	MOVWF	TRISA   ; puerto A configurado como entrada
	CLRF    TRISC	; puerto D y C envian señales a la matriz de leds
	CLRF	TRISD   ; puerto D y C configurado como salida
	MOVLW	B'11111111'
	MOVWF	TRISB   ; puerto B configurado como entrada
	banksel	PORTB	
    clrf	PORTB
    banksel	PORTC	
    clrf	PORTC
    banksel	PORTD
    clrf	PORTD
	MOVLW	.4
	MOVWF	aleatorio
	CLRF    contador

	;banksel T2CON
	;movlw b'00000100'  ;habilitar el tmr2

	;PROGRAMACION DEL TMR0
	banksel	 OPTION_REG  
	movlw	 b'00000111'	;Programa TMR0 como temporizador
	movwf	 OPTION_REG     ;con preescalador de 256

	;INTERRUPCIONES EN EL REGHISTRO INTCON
	movlw  b'10101000'
	movwf  INTCON 

	;VALOR A CARGAR EN EL TMR0 ES DE 217 CON UN PREESCALADOR DE 255 Y UNA FRECUENCIA DE 4 MHZ PARA OBTENER UNA
	;INTERRUPCION CADA 10 MS
	movlw	.217		;Valor decimal 217	
	movwf	TMR0		;Carga el TMR0 con 217
	movlw	.150		;Cantidad de interrupciones a contar, como es el nivel 1, los topos aparecen cada 1.5 segundos.
	movwf	temporizador	;Nº de veces a repetir la interrupción
 
loop
    nop
    goto		loop		; Permanece en el lazo hasta que ocurra una interrupcion
;***********************************************************************************************

;lazo1
sector1
	nop
	call    retardo
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	return
sector2
	nop
	call    retardo
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	return
sector3
	nop
	call    retardo
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	return
scetor4
	nop
	call    retardo
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	goto 	lazo1
	return	
sector5
	nop
	call    retardo
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	return
sector6
	nop
	call    retardo
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	return
sector7
	nop
	call    retardo
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	return
sector8
	nop
	call    retardo
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	return
scetor9
	nop
	call    retardo
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	return
sector10
	nop
	call    retardo
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	return
sector11
	nop
	call    retardo
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	return
sector 12 
	nop
	call    retardo
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	return
sector13
	nop
	call    retardo
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	return
sector14
	nop
	call    retardo
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	return
sector15
	nop
	call    retardo
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	return
sector16
	nop
	call    retardo
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	return
;***************************************************************************
?; TABLA DE CONVERSION
TABLA
	ADDWF  PCL,F      ; PCL + W -> PCL
	RETLW  0x3F                        ; Retorna con el código del 0
	RETLW  0x06                        ; Retorna con el código del 1
	RETLW  0x5B                        ; Retorna con el código del 2
	RETLW  0x4F                        ; Retorna con el código del 3
	RETLW  0x66                        ; Retorna con el código del 4
	RETLW  0x6D                        ; Retorna con el código del 5
	RETLW  0x7D                        ; Retorna con el código del 6
	RETLW  0x07                        ; Retorna con el código del 7
	RETLW  0x7F                        ; Retorna con el código del 8
	RETLW  0x67                        ; Retorna con el código del 9
	END                    ; Fin del programa fuente

;***************************************************************************
retardo
	decfsz  contador
    goto 	retardo
	movlw   0xFF
	movwf	contador
    return

	
end