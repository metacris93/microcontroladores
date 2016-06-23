;;--------------------------------------------------------------------------------
;;
;; Libreria de subrutinas de retraso en microsegundos
;;
;; Escrito por Andrew M. Bishop y editado por Almejandro para el español
;;
;;--------------------------------------------------------------------------------
;;
;; Variables requeridas / Constantes para la funcion de retraso en microsegundos
;;
;; Constantrs:   CLOCK           - La velocidad del PIC en Hz
;;
;; Variables:   delay_temp       - Guarda un dato temporal
;;
;;--------------------------------------------------------------------------------


;;--------------------------------------------------------------------------------
;;
;; Subrutina para retraso por un numero de microsegundos (para diferentes velocidades del reloj)
;;
;; Parametros:  w (in)          - En W el numero de microsegundos que queremos esperar
;;
;;--------------------------------------------------------------------------------


		CBLOCK
		delay_temp
		ENDC

        IF      CLOCK==4000000

;; Reloj a 4 MHz  
;; Retraso Minimo = 25 us

Delay_us_0                        ;        
        movwf   delay_temp      ; 
        movlw   b'00000011'     ;
        andwf   delay_temp,W    ; 
        btfsc   STATUS,Z        ; 
        goto    delay_us_0mod4  ; 
        addlw   -1              ; 
        btfsc   STATUS,Z        ; 
        goto    delay_us_1mod4  ; 
        addlw   -1              ; 
        btfsc   STATUS,Z        ;
        goto    delay_us_2mod4  ; 

delay_us_3mod4
delay_us_1mod4
        nop                     ; 
        movlw   .5              ; 
        goto    delay_4us       ; 

delay_us_0mod4
        goto    $+1             ; 
        goto    $+1             ;
delay_us_2mod4
        nop                     ; 
        movlw   .5               ; 

delay_4us                       ; static delay 4 ins = 4us
        rrf     delay_temp,F    ; 1 ins
        rrf     delay_temp,F    ; 1 ins
        subwf   delay_temp,W    ; 1 ins
        andlw   b'00111111'     ; 1 ins

delay_4us_loop                  ; static delay 5+3 ins = 8us
        addlw   -1              ; 1 ins (static,loop)
        btfss   STATUS,Z        ; 1 ins (loop) / 2 ins (static)
        goto    delay_4us_loop  ; 2 ins (loop)
		nop
        return                  ; 2 ins (static)

        ENDIF   ; CLOCK==4000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==8000000

;; Reloj a 8 MHz  
;; Retraso Minimo = 9us para pares ==== 8 us para impares


Delay_us_0                      ;               [0mod2  1mod2]
        movwf   delay_temp      ; 1 ins          1      1
        btfsc   delay_temp,0    ; 1 ins / 2 ins  3      2
        goto    delay_2us       ; 2 ins                 4

delay_2us                       ; static delay 5 ins = 2.5us
        nop                     ; 1 ins
        rrf     delay_temp,F    ; 1 ins
        movlw   3               ; 1 ins
        subwf   delay_temp,W    ; 1 ins
		nop					; Comentar esta linea si quiere exactitud en retrasos pares, descomentar para impares	
        andlw   b'01111111'     ; 1 ins

delay_2us_loop                  ; static delay 5+3 ins = 4us
        addlw   -1              ; 1 ins (static,loop)
        btfss   STATUS,Z        ; 1 ins (loop) / 2 ins (static)
        goto    delay_2us_loop  ; 2 ins (loop)
		;goto	$+1				; Comentar esta linea si quiere exactitud en retraso impares, descomentar para pares.
		return                  ; 2 ins (static)
                       

        ENDIF   ; CLOCK==8000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==16000000

;; Reloj a 16 MHz  
;; Retraso Minimo = 3 us

;; Total         = delay (including load and call overhead)

Delay_us_0
delay_1us                       ; static delay 4 ins = 1us
        goto    $+1             ; 2 ins
		goto 	$+1               ; 1 ins
        addlw   -2              ; 1 ins

delay_1us_loop                  ; static delay 5+3 ins = 2us
        addlw   -1              ; 1 ins (static,loop)
        btfss   STATUS,Z        ; 1 ins (loop) / 2 ins (static)
        goto    delay_1us_loop  ; 2 ins (loop)
        return                  ; 2 ins (static)

        ENDIF   ; CLOCK==16000000

;;--------------------------------------------------------------------------------

        IF      CLOCK==20000000

;; Reloj a 20 MHz  
;; Retraso Minimo = 2 us

;; Total         = delay (including load and call overhead)

Delay_us_0
delay_1us                       ; static delay 3 ins = 0.6us
        goto    $+1             ; 2 ins
        addlw   -1              ; 1 ins
		nop

delay_1us_loop                  ; static delay 4+3 ins = 1.4us
        addlw   -1              ; 1 ins (static,loop)
        btfsc   STATUS,Z        ; 1 ins (static) / 2 ins (loop)
        return                  ; 2 ins (static)
        goto    delay_1us_loop  ; 2 ins (loop)

        ENDIF   ; CLOCK==20000000

;;--------------------------------------------------------------------------------
