	LIST		p=16F887			
	INCLUDE 	P16F887.INC	
	INCLUDE     Macro_Delays.INC
	
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_INTOSCIO	
	errorlevel	 -302
	CLOCK equ 4000000
	CBLOCK 0x20
		aleatorio    ; contendra numeros entre 0 y 15
		contador     ; contador de retardos
		temporizador ; contador de interrupciones
		dato
		cont_mul
		operando
		topo
		tempTMR0
		aciertos   ; lleva la cuenta de los aciertos del jugador
		nivel 	   ; lleva el numero de niveles del jugador
		fallidos   ; cuenta de las veces que falla el jugador
		victoria   ; esta variable determina si gano la partida
	ENDC

	   org	0x00		     	; vector de reset
       goto	MAIN			    ; salto a label "main"
       org	0x04       		    ; vector de interrupción  
       goto	INTERRUPCION 		; salto a interrupción

;**************************Funciones de Interrupciones***************************
;----------------------------Interrupcion principal------------------------------
;Selecciona la interrupcion adecuada											
INTERRUPCION						
	;Aqui verifica si se activo alguno de los pines del puertoB  				
	BTFSC		INTCON, RBIF	;Salta a una funcion de interrupcion			
	GOTO		INTRB			;dependiendo de cual bandera se activo
	BTFSC		INTCON,T0IF		;RBIF -> Bandera de cambio de estado del PORTB	
	GOTO		INTTMR0			;T0IF -> Bandera de desbordamiento del TMR0		
	RETFIE																		
;-----------------------------Interrupcion del PORTB-----------------------------
INTRB
	BTFSC		PORTB,0															
	GOTO		label0															
	BTFSC		PORTB,1															
	GOTO		label1															
	BTFSC		PORTB,2															
	GOTO		label2
	BTFSC		PORTB,3															
	GOTO		label3															
	BTFSC		PORTB,4														    
	GOTO		label4															
	BTFSC		PORTB,5															
	GOTO		label5
	BTFSC		PORTB,6															
	GOTO		label6															
	BTFSC		PORTB,7															
	GOTO		label7

FINISH
	bcf     INTCON, RBIF
	movf    aciertos,W ; de prueba hay que borrarlo
	movlw   .2         ; era 5 pero en la sustentacion subo de nivel por 2 aciertos
	xorwf   aciertos,W
	btfss    STATUS,2
	retfie
	incf    nivel,F
	clrf    aciertos
	RETFIE

;*****************************************************************************************************
label0
	clrf   PORTA
	movlw  0x00
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'	
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x04
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo   
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label1
	clrf   PORTA
	movlw  0x01
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'	
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x05
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label2
	clrf   PORTA
	movlw  0x02
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x06
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label3
	clrf   PORTA
	movlw  0x03
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x07
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label4
	clrf   PORTA
	movlw  0x08
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x0C
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label5
	clrf   PORTA
	movlw  0x09
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x0D
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label6
	clrf   PORTA
	movlw  0x0A
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x0E
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
label7
	clrf   PORTA
	movlw  0x0B
	xorwf  topo, W
	btfss  STATUS, 2  ;si el bit 2 del registro STATUS es 1 entonces el resultado de la operacion XOR es cero
	goto   $+7
	clrf   fallidos
	incf   aciertos,F
	movlw  b'00000001'
	movwf  PORTA
	clrf   PORTB
	GOTO   FINISH
	movlw  0x0F
	xorwf  topo, W
	btfss  STATUS, 2
	goto   no_acerto_topo
	movlw  b'00000001'
	movwf  PORTA
	clrf   fallidos
	clrf   PORTB
	incf   aciertos,F
	GOTO   FINISH
;*********************************************************************************


no_acerto_topo
	movlw  b'00000010'
	movwf  PORTA
	incf   fallidos  ; nueva linea	
	clrf   aciertos
	GOTO   FINISH

;------------------------------Interrupcion del TMR0----------------------------
;Genera una onda cuadrada a traves del pin RE2									
;El frecuencia de la onda cuadrada dependerá del sonido a emitir				
INTTMR0																			
	BCF			INTCON,T0IF		;se encera la bandera del TMR0					
	BTFSC		PORTE,2			;verifica el valor anterior de RE2,				
	GOTO		hacer0			;si estaba en alto lo pasa a bajo y viceversa	
	BSF			PORTE,2															
	MOVF		tempTMR0,w		;tempTMR0 es una variable que almacena el		
	MOVWF		TMR0			;valor inicial que debe tener el TMR0			
	RETFIE						;para que genere una interrupción cada 			
hacer0							;semiperiodo de la nota musical a emitir		
	BCF			PORTE,2															
	MOVF		tempTMR0,w														
	MOVWF		TMR0															
	RETFIE
	
;***************************************************************************
;****                                MAIN                                ***
;***************************************************************************
MAIN
;*************************     SETEO DE PUERTOS	   *************************
	BANKSEL 	OPTION_REG														
	MOVLW		0X01															
	MOVWF		OPTION_REG
	MOVLW		0X88															
	MOVWF		INTCON	;HABILITA INTERRUP. POR CAMBIO DE ESTADO PORTB
	BANKSEL 	TRISA
	MOVLW		B'11111111'
	MOVWF		TRISB   ; puerto B configurado como entrada
	CLRF    	TRISA   ; puerto A configurado como salida
	CLRF    	TRISC	; puerto D y C conectados a la matriz de leds
	CLRF		TRISD   ; puerto D y C configurado como salida
	CLRF		TRISE
	BANKSEL		ANSEL															
	CLRF		ANSEL			; configura puertos con entradas digitales		
	CLRF		ANSELH			; configura puertos con entradas digitales			
	BANKSEL		IOCB															
	MOVLW		B'11111111'																
	MOVWF		IOCB
	BCF			STATUS,RP0		;regresa al banco cero
	banksel		PORTA
	clrf		PORTA	
    clrf		PORTB	
    clrf		PORTC
    clrf		PORTD
	CLRF		PORTE
;****************************************************************************
;********			RETARDO PARA GENERAR EL SONIDO				*************
;****************************************************************************
	BSF			INTCON,T0IE														
	CALL		DO																
	Delay_s .1														
	CALL		RE																
	Delay_s .1
	BCF 		INTCON,T0IE
	Delay_s .2
;****************************************************************************
;**********************	INICIALIZACION DE VARIABLES *************************
;****************************************************************************
	movlw   .5
	movwf   dato
	MOVLW	.4
	MOVWF	aleatorio
	CLRF    contador    ; CONTADOR DE RETARDOS
	clrf    topo
	movlw   .1
	movwf   nivel
	clrf    aciertos
	clrf    fallidos
	clrf    victoria
;****************************************************************************

encendido_de_leds
	clrf   cont_mul
	movlw  .2
	movwf  cont_mul
	movf   aleatorio,0  ; w = aleatorio
	movwf  operando	   ; operando = w
multiplicacion
	addwf  operando,W  ; operando lleva la acumulacion de las sumas consecutivas
	decfsz cont_mul,F
	goto   multiplicacion

	movwf  operando
	movf   dato,0        ; W = dato 
 	addwf  operando,W    ; W = operando + dato(que es W)
	andlw  0x0F
	movwf  topo

	;****** es igual a 15 *******
	movlw  0x0F ; 15
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector16
	goto   $+1
	;****** es igual a 14 *******
	movlw  0x0E ; 14
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector15
	goto   $+1
	;****** es igual a 13 *******
	movlw  0x0D ; 13
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector14
	goto   $+1
	;****** es igual a 12 *******
	movlw  0x0C ; 12
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector13
	goto   $+1
	;****** es igual a 11 *******
	movlw  0x0B ; 11
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector12
	goto   $+1
	;****** es igual a 10 *******
	movlw  0x0A ; 10
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector11
	goto   $+1
	;****** es igual a 9 *******
	movlw  0x09 ; 9
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector10
	goto   $+1
	;****** es igual a 8 *******
	movlw  0x08 ; 8
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector9
	goto   $+1
	;****** es igual a 7 *******
	movlw  0x07 ; 7
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector8
	goto   $+1
	;****** es igual a 6 *******
	movlw  0x06 ; 6
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector7
	goto   $+1
	;****** es igual a 5 *******
	movlw  0x05 ; 5
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector6
	goto   $+1
	;****** es igual a 4 *******
	movlw  0x04 ; 4
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector5
	goto   $+1
	;****** es igual a 3 *******
	movlw  0x03 ; 3
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector4
	goto   $+1
	;****** es igual a 2 *******
	movlw  0x02 ; 2
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector3
	goto   $+1
	;****** es igual a 1 *******
	movlw  0x01 ; 1
	xorwf  topo,W
	btfsc  STATUS,2
	goto   sector2
	goto   $+1
	;****** es igual a 0 *******
	movlw  0x00 ; 0
	xorwf  topo,W
	btfsc  STATUS,2
	goto    sector1

generando_aleatorio	
	movlw  .3  ; era con 8 pero en la sustentacion lo cambie a 3 
	xorwf  fallidos,W
	btfsc  STATUS,2
	GOTO   perdio_partida
	decfsz aleatorio, F ;aleatorio = aleatorio - 1
	goto   incrementando_dato
	movf   dato , W
	movwf  aleatorio	
incrementando_dato	
	movlw  0x0F
	xorwf  dato,W
	btfss  STATUS,2 ;verificamos si el resultado logico es igual a 15, de ser asi lo seteamos a cero
	incf   dato , F
	goto   encendido_de_leds	
lazo
	movlw  .1
	xorwf  nivel,W
	btfsc  STATUS,2
	goto   llamar_delay_2s
	movlw  .2
	xorwf  nivel,W
	btfsc  STATUS,2
	goto   llamar_delay_1s 			 
	movlw  .3
	xorwf  nivel,W
	btfsc  STATUS,2
	goto   llamar_delay_ms
	movlw  .1
	movwf  nivel
	clrf   aciertos
	goto   generando_aleatorio

llamar_delay_2s
				Delay_s .2
				goto generando_aleatorio

llamar_delay_1s
 				;Delay_s .1
				Delay_s .2
				goto generando_aleatorio

llamar_delay_ms
				movlw .2 ; era 5 pero en la sustentacion subo de nivel por 2 aciertos
				xorwf aciertos,W
				btfsc STATUS,2
				goto gano_partida
				;Delay_ms .255
				;Delay_ms .255
				Delay_s .2
				goto generando_aleatorio

;***********************************************************************************************
; Cuando el jugador pierde, la partida se termina mostrando en el display PD
perdio_partida
	BSF			INTCON,T0IE
	CALL		RE																
	Delay_s     .1
	BCF			INTCON,T0IE
lazo_infinito_perdida
	nop
GOTO lazo_infinito_perdida
;***********************************************************************************************
gano_partida
	BSF			INTCON,T0IE
	CALL		RE																
	Delay_s     .1
	BCF			INTCON,T0IE
lazo_infinito_victoria
	nop
GOTO lazo_infinito_victoria
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


;*********************************************************************************
;------------------------------SUBRUTINAS MUSICALES-----------------------------;*
;-------------------------------------nota do-----------------------------------;*
DO																				;*
	MOVLW	0X11																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;-------------------------------------nota re-----------------------------------;*
RE																				;*
	MOVLW	0X2C																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;-------------------------------------nota mi-----------------------------------;*
MI																				;*
	MOVLW	0X42																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;-------------------------------------nota fa-----------------------------------;*
FA																				;*
	MOVLW	0X4D																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;------------------------------------nota sol-----------------------------------;*
SOL																				;*
	MOVLW	0X60																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;-------------------------------------nota la-----------------------------------;*
LA																				;*
	MOVLW	0X72																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;-------------------------------------nota si-----------------------------------;*
SI																				;*
	MOVLW	0X82																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN																		;*
;----------------------------------nota do agudo--------------------------------;*
do																				;*
	MOVLW	0X88																;*
	MOVWF	TMR0																;*
	MOVWF	tempTMR0															;*
	RETURN

	INCLUDE     delay_s.INC
	INCLUDE     delay_ms.INC	
	END                    ; Fin del programa fuente