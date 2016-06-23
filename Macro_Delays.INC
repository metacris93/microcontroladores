;;------------------------------------------------------------------------------------
;;
;; En esta libreria definimos las macros para los retardos usados en las librerias:
;; delay_s.INC, delay_ms.INC y delay_us.INC. Con ello con las simples instrucciones
;; Definidas en las macros, podemos hacer mas leible y facil la programacion de nuestros
;; retardos en ensamblador.
;;
;;-----------------------------------------------------------------------------------
;; ADVERTENCIA: Recordad llamar esta libreria antes que las librerias con los retardos,
;; caso contrario, el compilador les dara un error.
;;-----------------------------------------------------------------------------------


;; Definicion de las macros para los retardos
		
Delay_s  MACRO  Tiempo_delay
		movlw	Tiempo_delay
		call	Delay_s_0
		ENDM		

Delay_ms  MACRO  Tiempo_delay
		movlw	Tiempo_delay
		call 	delay_ms_0
		ENDM		
		
Delay_us  MACRO  Tiempo_delay
		movlw	Tiempo_delay
		call 	Delay_us_0
		ENDM		
		
;;--------------------------------------------------------------------------------
