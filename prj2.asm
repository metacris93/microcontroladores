	LIST		p=16F887			
	INCLUDE 	P16F887.INC		
	INCLUDE     Macro_Delays.INC
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC&_INTOSCIO
	errorlevel	 -302
	CLOCK equ 4000000

	CBLOCK 0x20
		seleccion
		contador
		decenas
		unidades
		dec_cod
		uni_cod
		nivel
	ENDC

;********************************************************************************
;PROGRAMA
	ORG	0x00		;Vector de RESET
	GOTO	MAIN
	Org	    0x04        	; vector de interrupción  
    Goto	INTERRUPCION

;********************************************************************************

MAIN
;***********************     SETEO DE PUERTOS	   ******************************
	BANKSEL	    ANSEL		;Selecciona el Bank3
	CLRF		ANSEL
	CLRF		ANSELH
	BANKSEL 	TRISA		;Selecciona el Bank1
	movlw       0xFF
	movwf		TRISB		;PORTA configurado como entrada
	clrf	    TRISC       ; configuro PORTC COMO SALIDA
	clrf        TRISD		; configuro PORTD COMO SALIDA      
	BANKSEL 	PORTA		;Selecciona el Bank0		
	CLRF		PORTA		;Borra latch de salida de PORTB		
	CLRF        PORTC
	clrf        PORTD
	clrf		PORTB

;*********************		DECLARACION DE VARIABLES		*********************
	movlw   .1
	movwf   decenas    ; las decenas me reprentan el nivel
	clrf	unidades   ; las unidades me representan los aciertos del jugador
	clrf    dec_cod
	clrf 	uni_cod
	clrf	seleccion
	;movlw   .1
	;movwf   nivel	
	;movf  nivel, W
	;call  tabla
	;movwf dec_cod
	;movf  dec_cod, W
	;movwf  PORTC
	;banksel  PORTD
	;bsf	  PORTD,0
	;bcf	  PORTD,1	
	;CLRW
	;movwf  PORTC
	;bsf    PORTD,1
	;bcf    PORTD,0	
	banksel	    OPTION_REG	; Bank containing register OPTION_REG
	movlw		b'00000111'	;carga divisor con 255, se lo aplica a TMR0
					;PSA =0 (BIT 3); se aplica el divisor al TMR0
					;TOCS=0 (BIT 5); TMR0 origen de pulsos Fosc/4
	movwf		OPTION_REG

	movlw		b'10110000'	;habilita interrupción por Timer 0 y Global
				;GIE=1 (BIT 7); habilita interrupciones globales 
				;TMR0IE=1 (BIT 5); habilita interrupciones por TMR0
 			    ;INTE=1 (BIT 4); habilita interrupciones por RB0  
	movwf		INTCON

	BANKSEL	    TMR0		;Selecciona el Bank0
	movlw		.217		;Valor decimal 217	
	movwf		TMR0		;Carga el TMR0 con 217

LOOP   	
	nop
	;BTFSS		PORTA,0															
	;GOTO		LOOP
    ;GOTO        label1															
GOTO LOOP

;*******************************************************************************
INTERRUPCION
	btfss  INTCON,TMR0IF
	goto   increment	
	movf   seleccion,W
	btfsc  STATUS,2
	goto   etiqueta_decenas

etiqueta_unidades
	 movf     unidades,W
	 call     tabla
	 movwf    uni_cod
	 movf     uni_cod,W
	 banksel  PORTD 
	 bsf	  PORTD,0
	 bsf	  PORTD,1
	 movwf    PORTC
	 bcf      PORTD,1	
	 comf     seleccion,F
	 goto     timer0

etiqueta_decenas
   	 movf     decenas,W
	 call     tabla
	 movwf    dec_cod
     movf     dec_cod,W
	 banksel  PORTD
	 bsf	  PORTD,0
	 bsf	  PORTD,1
	 movwf    PORTC
	 bcf      PORTD,0
	comf      seleccion,F

timer0	
	bcf		INTCON,TMR0IF	; Clears interrupt flag TMR0IF
	movlw 	~.39
   	movwf 	TMR0      		;Repone el TMR0 con ~.39
	goto	Seguir

increment
	INCF 	unidades,f	
	movlw	.6
	subwf	unidades,w
	btfss	STATUS,2
	goto	fin_RB0
	clrf	unidades
	incf	decenas
	movlw	.4
	subwf	decenas,w
	btfss	STATUS,2
	goto	fin_RB0
	clrf	decenas

fin_RB0
	bcf		INTCON,INTF

Seguir
	retfie

inc_unidades
	INCF 	unidades,f
	banksel  PORTA
	bcf      PORTA,0
	goto    fin_RB0

inc_decenas
	incf	decenas,F
	banksel  PORTA
	bcf      PORTA,0
	goto    fin_RB0


;label1 
;	 movf     unidades,W
;     xorlw    b'00001010'
;	 btfss	  STATUS,2
;     goto     continuar
; en las siguientes lineas hay que modificar cuando el jugador haya acertado 5 veces, entonces
; lo que hay que hacer es aumentar en uno la decena
;	 clrf     unidades
;	 banksel  PORTA
;	 bcf      PORTA,0
;	 goto     LOOP
;continuar
;	 movf     unidades,W
;	 call     tabla
;	 movwf    uni_cod
;	 movf     uni_cod,W
;	 banksel  PORTD 
;	 bsf	  PORTD,0
;	 bsf	  PORTD,1
;	 movwf    PORTC
;	 bcf      PORTD,1
;	 incf     unidades,F
;	 banksel  PORTA
;	 bcf      PORTA,0
;	 goto     LOOP	

; TABLA DE CONVERSION---------------------------------------------------------

tabla
        ADDWF   PCL,F       	; PCL + W -> PCL					
       	RETLW   0x3F     	; Retorna con el código del 0
		RETLW	0x06		; Retorna con el código del 1
		RETLW	0x5B		; Retorna con el código del 2
		RETLW	0x4F		; Retorna con el código del 3
		RETLW	0x66		; Retorna con el código del 4
		RETLW	0x6D		; Retorna con el código del 5
		RETLW	0x7D		; Retorna con el código del 6
		RETLW	0x07		; Retorna con el código del 7
		RETLW	0x7F		; Retorna con el código del 8
		RETLW	0x67		; Retorna con el código del 9

	INCLUDE     delay_ms.INC
	END	
	
	
