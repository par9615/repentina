ORG 0000H

/* DIRECCIONES PARA LOS CALCULOS INTERNOS DE LAS HORAS */

HORC1 EQU 030H
HORC0 EQU 031H
MINC1 EQU 032H
MINC0 EQU 033H
SEGC1 EQU 034H
SEGC0 EQU 035H
HORCAUX EQU 036H

/* SELECTOR DEL DISPLAY */
DISP_SEL EQU 037H

/* DIRECCIONES DEL DISPLAY DE LAS HORAS */
HORD EQU 038H
HORU EQU 039H
MIND EQU 03AH
MINU EQU 03BH
SECD EQU 03CH
SECU EQU 03DH

/*Inicialiar TMOD, TCON, IE, 