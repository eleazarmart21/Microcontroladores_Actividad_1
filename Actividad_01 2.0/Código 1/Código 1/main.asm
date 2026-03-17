; *************************************************************************
; PROYECTO: Actividad I - Microcontroladores 
; AUTOR: Josué Eleazar Santana Martínez, Luna Leyva Azul Desiré y Ramos Ramirez Alberto Carlos
; DESCRIPCIÓN: Generación de 100 números y ordenamiento (Bubble y Selection)
; *************************************************************************

.def temp     = r16 ;registro asignado para intercambios
.def contador1  = r17
.def contador2  = r18
.def dato1    = r19
.def dato2    = r20
.def n_pasadas = r21

.dseg
.org $0100
table_of_unsorted_numbers:     .byte 100 
table_of_sorted_numbers:  .byte 100

.cseg ;define un segmento de código en el programa
.org $0000
    rjmp main

main:
;*******Inicializar Stack Pointer*******
    ldi temp, low(RAMEND) ;carga una constante de 8 bit en el r16
    out SPL, temp ;transfiere archivos de un registro a un puerto de salida
    ldi temp, high(RAMEND)
    out SPH, temp

    rcall generar_aleatorios  ;realiza una llamada a una dirección dentro del código
    rcall copiar_a_cod1       
    rcall sort_bubble         

fin: 
    rjmp fin ;salto relativo, se suma al contenido actual del contador de programa

;******Generador de números******
generar_aleatorios:
    ldi ZL, low(table_of_unsorted_numbers)
	;carga un byte de la memoria en el registro que sigue a HL y la decrementa
	;Low
    ldi ZH, high(table_of_unsorted_numbers)
	;High
    ldi contador2, 100
    ldi contador1, $1A 
loop_gen:
    mov temp, contador1 ;nos permite transferir archivos entre
	;el registro 16 y el registro 17
    lsr contador1
	;desplaza dos bits de Rd una posición a la derecha
    brcc no_xor
	;realiza un desvio condicional, test de carry
    ldi temp, $1D
    eor contador1, temp ;or exclusiva entre resgistros
no_xor:
    st Z+, contador1 ;texto estructurado
    dec contadoe2 ;representación decimal de numeros, es decir, convertir hexa a decimal
    brne loop_gen ;realiza un salto conidcional cuendo la variable anterior
	;no es igual a cero
    ret ;se extrae la dirección de retorno de la pila y lo coloca en 
	;el regisro de instrucciones

; --- Copia a tabla de destino ---
copiar_a_cod1:
    ldi contador2, 100
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi XL, low(table_of_sorted_numbers)
    ldi XH, high(table_of_sorted_numbers)
loop_c1:
    ld temp, Z+ ;cargar un valor de r16 a el r destino
    st X+, temp
    dec contador2
    brne loop_c1
    ret

; --- ALGORITMO 1: BUBBLE SORT ---
sort_bubble:
    ldi n_pasadas, 100
b_ext:
    ldi ZL, low(table_of_sorted_numbers)
    ldi ZH, high(table_of_sorted_numbers)
    ldi contador2, 99
b_int:
    ld dato1, Z+
    ld dato2, Z
    cp dato2, dato1 ;realiza una comparación entre r20 y r19
    brge no_swap ; despues de comparar los valores, envia una etiqueta si
	;el primer valor es igual o mayor que el segundo.
    st Z, dato1
    st -Z, dato2
    ld temp, Z+
no_swap:
    dec contador2
    brne b_int
    dec n_pasadas
    brne b_ext
    ret