/* ¡ngel ¡vila y Miguel Hern·ndez (Alondra Macias no ha llegado) */


/* VALORES EN HEXA PARA MOSTRAR LOS NUMEROS EN EL DISPLAY */

CERO   EQU 040H
UNO    EQU 079H
DOS    EQU 024H
TRES   EQU 030H
CUATRO EQU 019H
CINCO  EQU 012H
SEIS   EQU 003H
SIETE  EQU 078H
OCHO   EQU 000H
NUEVE  EQU 018H

/* VALOR PARA SABER QUE LE PRESIONAMOS AL BOTON DE INCREMENTAR EN LA INT0 */
INC_PRESIONADO EQU 069H

/* DIRECCIONES PARA LOS CALCULOS INTERNOS DE LAS HORAS */

HORC1 EQU 030H
HORC0 EQU 031H
MINC1 EQU 032H
MINC0 EQU 033H
SEGC1 EQU 034H
SEGC0 EQU 035H
HORCAUX EQU 036H

/* DIRECCIONES DEL DISPLAY DE ACTUALIZACIONES */
HORA1 EQU 038H
HORA0 EQU 039H
MINA1 EQU 03AH
MINA0 EQU 03BH
SEGA1 EQU 03CH
SEGA0 EQU 03DH

/* DIRECIONES DEL DISPLAY REAL */
HORR1 EQU 03EH
HORR0 EQU 03FH
MINR1 EQU 040H
MINR0 EQU 041H
SEGR1 EQU 042H
SEGR0 EQU 043H

/* SELECTOR DEL DISPLAY */
DISP_SEL EQU 037H

/*DIRECCIONES TIMER 2*/
T2CON EQU 00C8H
RCAP2L EQU 00CAH
RCAP2H EQU 00CBH
TL2 EQU 00CCH
TH2 EQU 00CDH
TF2 EQU 00CFH
	
/* DIRECCIONES PARA CALCULOS INTERNOS DE ALARMAS */
ALHC1 EQU 047H
ALHC0 EQU 048H
ALMC1 EQU 049H
ALMC0 EQU 04AH
ALSC1 EQU 04BH
ALSC0 EQU 04CH

/* DIRECCIONES DEL DISPLAY DE ALARMA DE ACTUALIZACIONES */
ALHA1 EQU 04DH
ALHA0 EQU 04EH
ALMA1 EQU 04FH
ALMA0 EQU 050H
ALSA1 EQU 051H
ALSA0 EQU 052H

/* DIRECCIONES DEL DISPLAY DE ALARMA REALES */
ALHR1 EQU 053H
ALHR0 EQU 054H
ALMR1 EQU 055H
ALMR0 EQU 056H
ALSR1 EQU 057H
ALSR0 EQU 058H

/* AUXILIAR DEL ACUMULADOR PARA NO PERDER SU VALOR DURANTE UNA SUBRUTINA */
AAUX EQU 044H

/* CONTADORES */
CUENTA20 EQU 0045H
CUENTA20_2 EQU 0046H

/* BIT DE ALARMA PRENDIDA */
ALARMA_ON EQU 059H
	
/* VARIABLES PARA DEBOUNCER */
REBOTE EQU 05AH
PRESIONADO EQU 05BH
	
/* VARIABLES PARA ESTADOS */
ESTADO EQU 05CH

/* ================= VECTORES DE INTERRUPCION ========================= */
ORG 0000H
	JMP INICIALIZAR
 
ORG 0003H
	JMP IEXT0
	
	
ORG 000BH
	JMP ITIM0

ORG 0013H
	JMP IEXT1

ORG 001BH
	JMP ITIM1

ORG 002BH
	CLR TF2
	JMP ITIM2
/* ================= VALORES INICIALES ========================= */

/* VALORES INICIALES DE LA HORA PARA CALCULOS (12:00:00) */

INICIALIZAR: 
MOV HORC1, #00H
MOV HORC0, #09H
MOV MINC1, #05H
MOV MINC0, #09H
MOV SEGC1, #05H
MOV SEGC0, #05H

/* VALORES INICIALES DE LA HORA PARA EL DISPLAY DE ACTUALIZACIONES */
MOV HORA1, #CERO
MOV HORA0, #NUEVE
MOV MINA1, #CINCO
MOV MINA0, #NUEVE
MOV SEGA1, #CINCO
MOV SEGA0, #CINCO

/* VALORES INICIALES DE LA HORA PARA EL DISPLAY REAL */
MOV HORR1, #CERO
MOV HORR0, #CERO
MOV MINR1, #CERO
MOV MINR0, #CERO
MOV SEGR1, #CERO
MOV SEGR0, #CERO

/* VALORES INICIALES DE LOS REGISTROS */
MOV R2, #00H
MOV R3, #00H
MOV R4, #00H
MOV R5, #00H
MOV R6, #00H
MOV R7, #00H

/* VALORES INICIALES DE CALCULOS INTERNOS DE ALARMAS */
MOV ALHC1, #01H
MOV ALHC0, #00H
MOV ALMC1, #00H
MOV ALMC0, #00H
MOV ALSC1, #00H
MOV ALSC0, #00H

/* VALORES INICIALES DEL DISPLAY DE ALARMA DE ACTUALIZACIONES */
MOV ALHA1, #00H
MOV ALHA0, #00H
MOV ALMA1, #00H
MOV ALMA0, #00H
MOV ALSA1, #00H
MOV ALSA0, #00H

/* VALORES INICIALES DEL DISPLAY DE ALARMA REALES */
MOV ALHR1, #00H
MOV ALHR0, #00H
MOV ALMR1, #00H
MOV ALMR0, #00H
MOV ALSR1, #00H
MOV ALSR0, #00H

/* VALORES INICIALES DEL AUXILIAR Y EL SELECTOR DEL DISPLAY */
MOV DISP_SEL, #00H
MOV AAUX, #00H

/* INICIA ALARMA COMO APAGADA */
CLR ALARMA_ON

/* NO SE ESTA PRESIONANDO */
CLR REBOTE
CLR PRESIONADO

/* ESTADO DE RELOJ */
CLR ESTADO

/* ================= TIMER 2 ========================= */


/*INICIALIZAR TIMER 2*/
MOV RCAP2H, #HIGH(-50000); CUENTE 500uS PARTE ALTA
MOV RCAP2L, #LOW(-50000)
MOV TH2, #HIGH(-50000)
MOV TL2, #LOW(-50000)
MOV T2CON, #00000100B



/* ================= TIMER 0 Y 1 ========================= */
/* INICIALIZAR TIMER 0 Y 1
- T0 EN AUTO DE 8, T1 EN AUTO DE 8
- VALORES DE CONTROL
- INTERRUPCIONES
- FALTA IP
*/
MOV TMOD, #22H 
MOV TCON, #05h ; NADA HABILITADO
MOV IE, #10101111B
MOV IP, #00101000B ; PRIORIDAD T2 Y T1, NO SE INTERRUMPEN

/* VALORES INICIALES PARA TIMER 0 Y 1 CON AUTORECARGA */
MOV TH1, #-200
MOV TL1, #-200
SETB TR1 ;INICIA TIMER 1

MOV DPTR, #1000H ;INICIALIZAR DPTR EN LA TABLA BCD

MOV TH0, #-200 
MOV TL0, #-200
SETB TR0

/*VALORES INICIALES PARA VARIABLES DE TIMERS*/
MOV CUENTA20, #00H
MOV CUENTA20_2, #00H
MOV R0, #CUENTA20
MOV R1, #CUENTA20_2


/* ================================================ */
/* =                                              = */
/* =                    MAIN                      = */
/* =                                              = */
/* ================================================ */

/* ================= INTERRUPCIONES ========================= */

MAIN:
SJMP $
	
IEXT0:
	;CLR EX0
	CPL P1.0
	MOV AAUX, A					; Movemos al auxiliar lo de A para no perder su valor
	MOV A, #INC_PRESIONADO		; Movemos un valor ya determinado a A para que cuando llamemos la sig subrutina
	LCALL INCRELOJ				; esta sepa que vamos a incrementar los minutos en vez de los segundos
	MOV A, AAUX					; Regresamos a A el valor que tenia antes de la interrupcion
	
	FIN_IEXT0: RETI
	
	
IEXT1:	
		CPL ESTADO
		
		FIN_IEXT1: RETI
		
ITIM2:
		INC CUENTA20
		CJNE @R0, #020D, FIN_ITIM2 
		
		INC SEGC0		
		MOV CUENTA20, #00H
		LCALL INCRELOJ	

		FIN_ITIM2: RETI


ITIM1:	
        /*INC CUENTA50
		CJNE R2, #050DM, FIN_ITIM1		
		MOV CUENTA50,#00H*/
	
		FIN_ITIM1: RETI

ITIM0:
	INC CUENTA20_2
	CJNE @R1, #020D, FIN_ITIM0 
	LCALL REFRESH
	MOV CUENTA20_2, #00H
	FIN_ITIM0: RETI

/* ================= SUBRUTINAS ========================= */

/* SUBRUTINA PARA EL REFRESH DEL DISPLAY (CADA 4ms) */
REFRESH: MOV AAUX, A
		 MOV A, DISP_SEL
		 JB ESTADO, CASE0A
		 
		 CASE0: CJNE A,#00H, CASE1 ; si no es el caso 0, checa si es el 1
			MOV A, SEGC0 ; si es el caso, tomamos lo de la unidad de segundo
			LCALL BCDTOA ; ese numero en A, lo convertimos al hexa de 7 segmentos que representa al numero
			MOV SEGA0, A ; lo movemos a la unidad de segundo de actualizaciones (ahorita eso no hace nada)
			MOV P0,#11111110B ; prendemos el display de hasta la derecha			
			; ESTADOS
			; MOV A, SEGR0
			JMP FIN_REFRESH ; nos vamos al fin de la subrutina
				
		 CASE1: CJNE A,#01H, CASE2
			MOV A, SEGC1
			LCALL BCDTOA
			MOV SEGA1, A
			MOV P0,#11111101B
			JMP FIN_REFRESH
				
		 CASE2: CJNE A,#02H, CASE3
			MOV A, MINC0
			LCALL BCDTOA
			MOV MINA0, A
			MOV P0,#11111011B
			JMP FIN_REFRESH
				
		 CASE3: CJNE A,#03H, CASE4
			MOV A, MINC1
			LCALL BCDTOA
			MOV MINA1, A
			MOV P0,#11110111B
			JMP FIN_REFRESH
				
		 CASE4: CJNE A,#04H, CASE5
			MOV A, HORC0
			LCALL BCDTOA
			MOV HORA0, A
			MOV P0,#11101111B
			JMP FIN_REFRESH
				
		 CASE5:	MOV DISP_SEL, #00H
			MOV A, HORC1
			LCALL BCDTOA
			MOV HORA1, A
			MOV P0,#11011111B
			JMP RST_REFRESH

		CASE0A: CJNE A,#00H, CASE1A ; si no es el caso 0, checa si es el 1
			MOV A, ALSC0 ; si es el caso, tomamos lo de la unidad de segundo
			LCALL BCDTOA ; ese numero en A, lo convertimos al hexa de 7 segmentos que representa al numero
			MOV P0,#11111110B ; prendemos el display de hasta la derecha			
			; ESTADOS
			; MOV A, SEGR0
			JMP FIN_REFRESH ; nos vamos al fin de la subrutina
				
		 CASE1A: CJNE A,#01H, CASE2A
			MOV A, ALSC1
			LCALL BCDTOA
			MOV P0,#11111101B
			JMP FIN_REFRESH
				
		 CASE2A: CJNE A,#02H, CASE3A
			MOV A, ALMC0
			LCALL BCDTOA
			MOV P0,#11111011B
			JMP FIN_REFRESH
				
		 CASE3A: CJNE A,#03H, CASE4A
			MOV A, ALMC1
			LCALL BCDTOA
			MOV P0,#11110111B
			JMP FIN_REFRESH
				
		 CASE4A: CJNE A,#04H, CASE5A
			MOV A, ALHC0
			LCALL BCDTOA
			MOV P0,#11101111B
			JMP FIN_REFRESH
				
		 CASE5A:	MOV DISP_SEL, #00H
			MOV A, ALHC1
			LCALL BCDTOA
			MOV P0,#11011111B
			JMP RST_REFRESH
		
		FIN_REFRESH: INC DISP_SEL ; pasamos al siguiente caso
		RST_REFRESH: MOV P2, A ; los hexa de 7 segmentos los mandamos al P2 para que prendan los segmentos que tocan
			     MOV A, AAUX ; regresamos lo que estaba en el A antes de entrar a la subrutina
			     RET

/* BCD */
BCDTOA: MOVC A,@A + DPTR
	RET
	

/* INCREMENTAR SEGUNDOS*/
INCRELOJ: MOV AAUX, A
		  
		  COMP_PRESIONADO: CJNE A, #INC_PRESIONADO, COMP_SEGC0 ; Si el boton de inc minutos no ue presionado, es porque vamos a inc seg
						   INC MINC0 ; De lo contrario, incrementamos minutos
						   JMP COMP_MINC0 ; Y procedemos a hacer los calculos normales
		  
		  COMP_SEGC0: MOV A, #10D
					  CJNE A, SEGC0, FIN_INCRELOJ ; si las unidades de segundos no son 10, terminamos las comparaciones
			          MOV SEGC0, #0D ; si es 10D lo regresa a 0
			          INC SEGC1 ; y luego incrementa las decenas de segundo
			  
		  COMP_SEGC1: MOV A, #06D
					  CJNE A, SEGC1, FIN_INCRELOJ
					  MOV SEGC1, #0D
					  INC MINC0
					  
	      COMP_MINC0: MOV A, #10D
					  CJNE A, MINC0, FIN_INCRELOJ2
					  MOV MINC0, #0D
					  INC MINC1
					  		  
	      COMP_MINC1: MOV A, #06D
					  CJNE A, MINC1, FIN_INCRELOJ2
					  MOV MINC1, #0D
					  INC HORC0
					  		  
	      COMP_HORC0: MOV A, #0AH 
					  CJNE A, HORC0, COMP_HORC02 ; si las horas no son 10D, pasamos a compararlas otra vez a ver si son 4
					  
					  MOV HORC0, #0D ; si son 10, las hacemos 0 
					  INC HORC1 ; incrementamos las decenas de hora
					  JMP COMP_HORC1 ; pasamos a la siguiente comparacion de las decenas de hora
					  
		  COMP_HORC02:  MOV A, #04H
					    CJNE A, HORC0, FIN_INCRELOJ2 ; si las unidades de hora tampoco son 4, terminamos las comp
						JMP COMP_HORC03 ; como son 4, tenemos que comparar otra vez a ver si las decenas de hora son 2
						
		  COMP_HORC03: MOV A, #02H
					   CJNE A, HORC1, FIN_INCRELOJ2 ; si no son 2, salimos
					   MOV HORC0, #0D ; de lo contrario bajamos las U a 0, porque ser√≠an las 00:00:00
					   INC HORC1 ; incrementamos las decenas
					   JMP COMP_HORC1 ; pasamos a la sig comparacion
			  
		  COMP_HORC1: MOV A, #03D
					  CJNE A, HORC1, FIN_INCRELOJ2
					  MOV HORC1, #0D
					  JMP FIN_INCRELOJ2		  
					  
		FIN_INCRELOJ: MOV A, AAUX
					  RET
					  
		FIN_INCRELOJ2: ACALL CHECAR_ALARMA
                       ACALL PRENDE_ALARMA
					   MOV A, AAUX
					   RET

/* CHECAR SI YA ES LA HORA DE LA ALARMA */
CHECAR_ALARMA:  MOV AAUX, A

                CHECAR_ALARMA_H1:   MOV A, HORC1 ; vamos a comparar primero las decenas de hora
                                    CJNE A, ALHC1, CHECAR_ALARMA_FINB ; si son iguales a las de la alarma seguimos comparando, si no, es el fin en el que no es la hora de la alarma

                CHECAR_ALARMA_H0:   MOV A, HORC0
                                    CJNE A, ALHC0, CHECAR_ALARMA_FINB

                CHECAR_ALARMA_M1:   MOV A, MINC1
                                    CJNE A, ALMC1, CHECAR_ALARMA_FINB

                CHECAR_ALARMA_M0:   MOV A, MINC0
                                    CJNE A, ALMC0, CHECAR_ALARMA_FINB

                CHECAR_ALARMA_SUCC: SETB ALARMA_ON ; se prende el bit que dice que es la hora de la alarma

                CHECAR_ALARMA_FINA:  MOV A, AAUX
                                    RET

                CHECAR_ALARMA_FINB: CLR ALARMA_ON ; se apaga el bit que dice que es la hora de la alarma
                                    MOV A, AAUX
                                    RET

/* PRENDER ALARMA SI DEBE ESTAR PRENDIDA */

PRENDE_ALARMA: JNB ALARMA_ON, OFF ; si es la hora de la alarma, sigue a ON

ON: CLR P3.7 ; manda un 0 a donde tenemos conectada la bocina
JMP PRENDE_ALARMA_FIN ; se sale de la subrutina

OFF: SETB P3.7 ; mana un 1 a donde tenemos conectada la bocina
JMP PRENDE_ALARMA_FIN ; se sale de la subrutina

PRENDE_ALARMA_FIN: RET


/* ================= TABLA BCD ========================= */

	ORG 1000H
	DB 040H
	DB 079H
	DB 024H
	DB 030H
	DB 019H
	DB 012H
	DB 003H
	DB 078H
	DB 000H
	DB 018H

END
