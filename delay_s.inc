;;--------------------------------------------------------------------------------
;;
;; Libreria de subrutinas de retraso en segundos
;;
;; Escrito por Almejandro para el español
;;
;;--------------------------------------------------------------------------------
;;
;; Variables requeridas / Constantes para la funcion de retraso en segundos
;;
;; Constantrs:   CLOCK           - La velocidad del PIC en Hz
;;
;; Variables:   delay_temp       - Guarda un dato temporal
;;
;;--------------------------------------------------------------------------------


;;--------------------------------------------------------------------------------
;;
;; Subrutina para retraso por un numero de segundos (para diferentes velocidades del reloj)
;;
;; Parametros:  w (in)          - En W el numero de segundos que queremos esperar
;;
;;--------------------------------------------------------------------------------

		CBLOCK
		d1
		d2
		d3
		delay_temp
		ENDC


        IF      CLOCK==1000000

Delay_s_0
		movwf	delay_temp

Delay_s_1		
		movlw	0x4E
		movwf	d1
		movlw	0xC4
		movwf	d2

Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	Delay_s_2


		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1
		return


        ENDIF   ; CLOCK==1000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==2000000

Delay_s_0
		movwf	delay_temp

Delay_s_1		
		movlw	0x03
		movwf	d1
		movlw	0x18
		movwf	d2
		movlw	0x02
		movwf	d3

Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	Delay_s_2


		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1
		goto	$+1
		nop
		return



        ENDIF   ; CLOCK==2000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==4000000


Delay_s_0
		movwf	delay_temp

Delay_s_1	
		movlw	0x07
		movwf	d1
		movlw	0x2F
		movwf	d2
		movlw	0x03
		movwf	d3

Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	Delay_s_2


		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1
		goto	$+1
		nop
		return

	
        ENDIF   ; CLOCK==4000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==8000000

Delay_s_0
		movwf	delay_temp

Delay_s_1	
		movlw	0x10
		movwf	d1
		movlw	0x5D
		movwf	d2
		movlw	0x05
		movwf	d3

Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	Delay_s_2


		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1
		goto	$+1
		return


        ENDIF   ; CLOCK==8000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==16000000

Delay_s_0
		movwf	delay_temp

Delay_s_1		
		movlw	0x23
		movwf	d1
		movlw	0xB9
		movwf	d2
		movlw	0x09
		movwf	d3

Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	Delay_s_2


		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1
		goto	$+1
		return
	
        ENDIF   ; CLOCK==16000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==20000000


Delay_s_0
		movwf	delay_temp

Delay_s_1
		movlw	0x2C
		movwf	d1
		movlw	0xE7
		movwf	d2
		movlw	0x0B
		movwf	d3
Delay_s_2
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	Delay_s_2

		decf	delay_temp,f
		btfss	STATUS,Z
		goto	Delay_s_1

		goto	$+1
		nop
		return

        ENDIF   ; CLOCK==20000000

;;--------------------------------------------------------------------------------
