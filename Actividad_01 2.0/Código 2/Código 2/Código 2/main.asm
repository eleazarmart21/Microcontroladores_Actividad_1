; *************************************************************************
; TÍTULO: Ordenamiento por Selección (Selection Sort) - Actividad I [cite: 3]
; AUTOR: Josué Eleazar Santana Martínez
; ESCUELA: FES Cuautitlán (UNAM)
; *************************************************************************

.def temp     = r16 ;definicion de datos
.def contador1  = r17
.def contador2  = r18
.def dato1    = r19
.def dato2    = r20
.def n_pasadas = r21

.dseg ;la directiva define el inicio de un segmento de datos
.org $0100
table_of_unsorted_numbers:     .byte 100 
table_of_sorted_numbers:  .byte 100 

.cseg ;define un segmento de código en el programa
.org $0000
    rjmp main

main:
    ldi temp, low(RAMEND) ;carga una constante de 8 bit en el r16
    out SPL, temp ;transfiere archivos de un registro (r16) a un puerto de salida
    ldi temp, high(RAMEND)
    out SPH, temp

    rcall numeros_aleatorios  ;realiza una llamada a una dirección dentro del código
    rcall copia2
    rcall seleccion   

fin: 
    rjmp fin ;salto relativo, se suma al contenido actual del contador de programa

numeros_aleatorios:
    ldi ZL, low(table_of_unsorted_numbers)
	;carga un byte de la memoria en el registro que sigue a HL y la decrementa
	;Low
    ldi ZH, high(table_of_unsorted_numbers) ;High
    ldi contador2, 100
    ldi contador1, $1A
loop_gen2:
    mov temp, contador1 
	;nos permite transferir archivos entre
	;el registro 16 y el registro 17
    lsr contador1
	;desplaza dos bits de Rd una posición a la derecha
    brcc no_xor
	;realiza un desvio condicional, test de carry
    ldi temp, $1D
    eor contador1, temp
	;or exclusiva entre resgistros
no_xor2:
    st Z+, contador1 ;texto estructurado
    dec contador2
	;representación decimal de numeros, es decir, convertir hexa a decimal
    brne loop_gen
	;realiza un salto conidcional cuendo la variable anterior
	;no es igual a cero
    ret
	;se extrae la dirección de retorno de la pila y lo coloca en 
	;el regisro de instrucciones

copia2:
;*****Copia a tabla de destino*****
    ldi contador2, 100
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi XL, low(table_of_sorted_numbers)
    ldi XH, high(table_of_sorted_numbers)
loop_c2:
    ld temp, Z+ 
	;cargar un valor de r16 a el r destino
    st X+, temp
    dec contador2
    brne loop_c2
    ret

seleccion:
    ldi XL, low(table_of_sorted_numbers)
    ldi XH, high(table_of_sorted_numbers)
    ldi n_pasadas, 100
s_base:
    ld dato1, X
    mov ZL, XL
    mov ZH, XH
    adiw ZL, 1
	;suma un valor inmediato en un registro de 16 bits
    mov r24, XL
    mov r25, XH
    mov contador2, n_pasadas
    dec contador2
	;representación decimal de numeros, es decir, convertir hexa a decimal
    breq s_done
	;realiza un salto de control en el programa
s_min:
    ld dato2, Z+
	;cargar un valor de r16 a el r destino
    cp dato2, dato1
	;realiza una comparación entre r20 y r19
    brsh s_next
	;hace un test de bandera carry y lo desvia
    mov dato1, dato2
    mov r24, ZL
    subi r24, 1
	;resta el valor inmediato de 16 bits en la instrucción
	;y almacena el resultado de nuevo en r24
    mov r25, ZH
s_next:
    dec contador2
    brne s_min
	;realiza un salto conidcional cuendo la variable anterior
	;no es igual a cero
    ld temp, X
    st X, dato1
	;texto estructurado
    mov ZL, r24
    mov ZH, r25
    st Z, temp
s_done:
    adiw XL, 1
    dec n_pasadas
    brne s_base
    ret
