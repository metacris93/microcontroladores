	LIST		p=16F887			
	INCLUDE 	P16F887.INC	
	INCLUDE     Macro_Delays.INC
	
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC&_INTOSCIO	
	errorlevel	 -302
	CLOCK equ 4000000
	CBLOCK 0x20
		aleatorio    ; contendra numeros entre 1 y 16
		contador     ; contador de retardos
		temporizador ; contador de interrupciones
		nivel
		dato
		cont_mul
		operando
		topo 
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
	goto fin_interrupcion_portb	
	
;***************************************************************************
;****                         INTERRUPCION                               ***
;***************************************************************************
interrupcion
	;btfss  INTCON,RBIE	
	goto   interrupcion_timer0
	;goto   Seguir_tmr0          ;aqui va interrupcion_portb

;***************************************************************************
;****                        INTERRUPCION_PORTB                          ***
;***************************************************************************	
interrupciom_portb
	banksel  IOCB
	btfsc    IOCB,0	
	goto  generar_random

	btfsc    IOCB,1
	goto  generar_random

	btfsc    IOCB,2
	goto  generar_random

	btfsc    IOCB,3
	goto  generar_random
	
	btfsc    IOCB,4
	goto  generar_random

	btfsc    IOCB,5
	goto  generar_random

	btfsc    IOCB,6
	goto  generar_random

	btfsc    IOCB,7	
	goto  generar_random
	goto  fin_interrupcion_portb

;**************************************************************************
;****                    FIN_INTERRUPCION_PUERTO_B                      ***
;**************************************************************************
fin_interrupcion_portb
	bcf INTCON,RBIF
	goto salir_interrupcion

;**************************************************************************
;****                     INTERRUPCION_TIMER0                           ***
;**************************************************************************
interrupcion_timer0
	decfsz 	    temporizador,f	;Decrementa el contador del timer0
    goto		Seguir_tmr0 
	movlw	    .150		  ;Cantidad de interrupciones a contar, como es el nivel 1, los topos aparecen cada 1.5 segundos.
	movwf   	temporizador  ;Nº de veces a repetir la interrupción    
mult
	clrf cont_mul
	movlw d'3'
	movwf cont_mul
	movf  aleatorio,W  ; w = aleatorio
	movwf operando	   ; operando = w
;multiplicacion
	addwf  operando,F  ; operando lleva la acumulacion de las sumas consecutivas
	decfsz cont_mul,F
	goto multiplicacion

	movf dato,W        ; W = dato 
 	addwf operando,W   ; W = operando + dato(que es W)
	andlw 0x0F
	movwf topo
 	
	;****** es igual a 15 *******
	movlw 0x0F ; 15
	xorwf topo,W
	btfsc STATUS,2
	call sector16
	goto $+1
	;****** es igual a 14 *******
	movlw 0x0E ; 14
	xorwf topo,W
	btfsc STATUS,2
	call sector15
	goto $+1
	;****** es igual a 13 *******
	movlw 0x0D ; 13
	xorwf topo,W
	btfsc STATUS,2
	call sector14
	goto $+1
	;****** es igual a 12 *******
	movlw 0x0C ; 12
	xorwf topo,W
	btfsc STATUS,2
	call sector13
	goto $+1
	;****** es igual a 11 *******
	movlw 0x0B ; 11
	xorwf topo,W
	btfsc STATUS,2
	call sector12
	goto $+1
	;****** es igual a 10 *******
	movlw 0x0A ; 10
	xorwf topo,W
	btfsc STATUS,2
	call sector11
	goto $+1
	;****** es igual a 9 *******
	movlw 0x09 ; 9
	xorwf topo,W
	btfsc STATUS,2
	call sector10
	goto $+1
	;****** es igual a 8 *******
	movlw 0x08 ; 8
	xorwf topo,W
	btfsc STATUS,2
	call sector9
	goto $+1
	;****** es igual a 7 *******
	movlw 0x07 ; 7
	xorwf topo,W
	btfsc STATUS,2
	call sector8
	goto $+1
	;****** es igual a 6 *******
	movlw 0x06 ; 6
	xorwf topo,W
	btfsc STATUS,2
	call sector7
	goto $+1
	;****** es igual a 5 *******
	movlw 0x05 ; 5
	xorwf topo,W
	btfsc STATUS,2
	call sector6
	goto $+1
	;****** es igual a 4 *******
	movlw 0x04 ; 4
	xorwf topo,W
	btfsc STATUS,2
	call sector5
	goto $+1
	;****** es igual a 3 *******
	movlw 0x03 ; 3
	xorwf topo,W
	btfsc STATUS,2
	call sector4
	goto $+1
	;****** es igual a 2 *******
	movlw 0x02 ; 2
	xorwf topo,W
	btfsc STATUS,2
	call sector3
	goto $+1
	;****** es igual a 1 *******
	movlw 0x01 ; 1
	xorwf topo,W
	btfsc STATUS,2
	call sector2
	goto $+1
	;****** es igual a 0 *******
	movlw 0x00 ; 0
	xorwf topo,W
	btfsc STATUS,2
	call sector1
	
	decfsz aleatorio, F ;aleatorio = aleatorio - 1
	goto fin_interrupcion_tmr0
	movf dato , W
	movwf aleatorio
	goto Seguir_tmr0	

fin_interrupcion_tmr0	
	movlw 0x0F
	xorwf dato,W
	btfss STATUS,2 ;verificamos si el resultado logico es igual a cero
	incf dato , F
	goto Seguir_tmr0
	;goto   multiplicacion
	;btfsc STATUS,C ; pregunto si hay un desbordamiento cuando el resultado es mayor a 255 y menor a 0
	
	
		
	;movf		unidades,w  	;Ya ocurrieron 150 interrupciones de 10ms(1500ms)
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

;contando
 	;movlw 		.150
    ;movwf	 	contador   	;Repone el contador con 100 

Seguir_tmr0    
	movlw 		.217			
    movwf 		TMR0      	  ;Repone el TMR0 con 217
	bcf		    INTCON,T0IF	  ;Repone flag del TMR0
	goto 		salir_interrupcion
salir_interrupcion
    RETFIE			          ;Retorno de interrupción

	
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
	movlw   .5
	movwf   dato
	MOVLW	.4
	MOVWF	aleatorio
	CLRF    contador
	clrf    topo
;INTERRUPCIONES EN EL REGISTRO INTCON, CAMBIOS DE ESTADO EN EL PUERTO B
	;movlw  b'10001000'
	;movwf  INTCON
; HABILITO LAS INTERRUPCIONES EN LOS 8 PINES DEL PUERTO B
	;banksel IOCB
	;movlw  b'11111111'
	;movwf  IOCB

encendido_de_leds
	clrf cont_1
	clrf cont_2
	clrf cont_3
	clrf cont_mul
	movlw .2
	movwf cont_mul
	movf  aleatorio,0  ; w = aleatorio
	movwf operando	   ; operando = w
multiplicacion
	addwf  operando,W  ; operando lleva la acumulacion de las sumas consecutivas
	decfsz cont_mul,F
	goto multiplicacion

	movwf operando
	movf dato,0        ; W = dato 
 	addwf operando,W   ; W = operando + dato(que es W)
	andlw 0x0F
	movwf topo

	;****** es igual a 15 *******
	movlw 0x0F ; 15
	xorwf topo,W
	btfsc STATUS,2
	goto sector16
	goto $+1
	;****** es igual a 14 *******
	movlw 0x0E ; 14
	xorwf topo,W
	btfsc STATUS,2
	goto sector15
	goto $+1
	;****** es igual a 13 *******
	movlw 0x0D ; 13
	xorwf topo,W
	btfsc STATUS,2
	goto sector14
	goto $+1
	;****** es igual a 12 *******
	movlw 0x0C ; 12
	xorwf topo,W
	btfsc STATUS,2
	goto sector13
	goto $+1
	;****** es igual a 11 *******
	movlw 0x0B ; 11
	xorwf topo,W
	btfsc STATUS,2
	goto sector12
	goto $+1
	;****** es igual a 10 *******
	movlw 0x0A ; 10
	xorwf topo,W
	btfsc STATUS,2
	goto sector11
	goto $+1
	;****** es igual a 9 *******
	movlw 0x09 ; 9
	xorwf topo,W
	btfsc STATUS,2
	goto sector10
	goto $+1
	;****** es igual a 8 *******
	movlw 0x08 ; 8
	xorwf topo,W
	btfsc STATUS,2
	goto sector9
	goto $+1
	;****** es igual a 7 *******
	movlw 0x07 ; 7
	xorwf topo,W
	btfsc STATUS,2
	goto sector8
	goto $+1
	;****** es igual a 6 *******
	movlw 0x06 ; 6
	xorwf topo,W
	btfsc STATUS,2
	goto sector7
	goto $+1
	;****** es igual a 5 *******
	movlw 0x05 ; 5
	xorwf topo,W
	btfsc STATUS,2
	goto sector6
	goto $+1
	;****** es igual a 4 *******
	movlw 0x04 ; 4
	xorwf topo,W
	btfsc STATUS,2
	goto sector5
	goto $+1
	;****** es igual a 3 *******
	movlw 0x03 ; 3
	xorwf topo,W
	btfsc STATUS,2
	goto sector4
	goto $+1
	;****** es igual a 2 *******
	movlw 0x02 ; 2
	xorwf topo,W
	btfsc STATUS,2
	goto sector3
	goto $+1
	;****** es igual a 1 *******
	movlw 0x01 ; 1
	xorwf topo,W
	btfsc STATUS,2
	goto sector2
	goto $+1
	;****** es igual a 0 *******
	movlw 0x00 ; 0
	xorwf topo,W
	btfsc STATUS,2
	goto sector1

decrementando_aleatorio	
	decfsz aleatorio, F ;aleatorio = aleatorio - 1
	goto incrementando_dato
	movf dato , W
	movwf aleatorio	
incrementando_dato	
	movlw 0x0F
	xorwf dato,W
	btfss STATUS,2 ;verificamos si el resultado logico es igual a 15, de ser asi lo seteamos a cero
	incf dato , F
	goto encendido_de_leds	

lazo
	Delay_s .2
	;call retardo_1s  ;genera retardos de 1 segundo
	goto decrementando_aleatorio
	 

    ;banksel T2CON
	;movlw b'00000100'  ;habilitar el tmr2

	;PROGRAMACION DEL TMR0
	;banksel	 OPTION_REG  
	;movlw	 b'00000111'	;Programa TMR0 como temporizador
	;movwf	 OPTION_REG     ;con preescalador de 256
	

	;VALOR A CARGAR EN EL TMR0 ES DE 217 CON UN PREESCALADOR DE 255 Y UNA FRECUENCIA DE 4 MHZ PARA OBTENER UNA
	;INTERRUPCION CADA 10 MS
	;movlw	.217		;Valor decimal 217	
	;movwf	TMR0		;Carga el TMR0 con 217
	;movlw	.150		;Cantidad de interrupciones a contar, como es el nivel 1, los topos aparecen cada 1.5 segundos.
	;movwf	temporizador	;Nº de veces a repetir la interrupción
 
;loop
;    nop
;    goto		loop		; Permanece en el lazo hasta que ocurra una interrupcion
;***********************************************************************************************

sector1
	nop
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	goto lazo
sector2
	nop
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	goto lazo
sector3
	nop
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	goto lazo
sector4
	nop
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'00111111'	
	movwf	PORTC
	goto  lazo	
sector5
	nop
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	goto lazo
sector6
	nop
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	goto lazo
sector7
	nop
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	goto lazo
sector8
	nop
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11001111'	
	movwf	PORTC
	goto lazo
sector9
	nop
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	goto lazo
sector10
	nop
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	goto lazo
sector11
	nop
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	goto lazo
sector12 
	nop
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11110011'	
	movwf	PORTC
	goto lazo
sector13
	nop
    movlw   b'11000000'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	goto lazo
sector14
	nop
    movlw   b'00110000'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	goto lazo
sector15
	nop
    movlw   b'00001100'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	goto lazo
sector16
	nop
    movlw   b'00000011'	
	movwf	PORTD
	movlw   b'11111100'	
	movwf	PORTC
	goto lazo

;***************************************************************************
retardo
		decfsz  contador
    	goto 	retardo
		movlw   0xFF
		movwf	contador
    	return
	
	INCLUDE     delay_s.INC	
	END                    ; Fin del programa fuente

