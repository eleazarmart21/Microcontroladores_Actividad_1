;
; Código 1.asm
;
; Created: 8/3/2026 14:24:23
; Author : VOSTRO
;


; Replace with your application code
; PROYECTO: Actividad I - Microcontroladores 
; AUTOR: Josué Eleazar Santana Martínez, Luna Leyva Azul Desiree, Ramos Ramírez Alberto Carlos
; Generación de 100 números y ordenamiento (Selection)

.include "m328pdef.inc"

.def temp     = r16
.def v_in  = r17
.def counter  = r18
.def dato1    = r19
.def dato2    = r20
.def n_pasadas = r21

.dseg
.org $0100
table_of_unsorted_numbers:     .byte 100 ; [cite: 7]
table_of_sorted_numbers_alg1:  .byte 100 ; [cite: 9]

.cseg
.org $0000
    rjmp main

main:
    ; Inicializar Stack Pointer
    ldi temp, low(RAMEND)
    out SPL, temp
    ldi temp, high(RAMEND)
    out SPH, temp

    rcall generar_aleatorios  
    rcall copiar_a_alg1       
    rcall sort_bubble         

fin: 
    rjmp fin

;  Generador de números 
generar_aleatorios:
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi counter, 100
    ldi v_in, $1A 
loop_gen:
    mov temp, v_in
    lsr v_in
    brcc no_xor
    ldi temp, $1D
    eor v_in, temp
no_xor:
    st Z+, v_in
    dec counter
    brne loop_gen
    ret

; Copia a tabla de destino 
copiar_a_alg1:
    ldi counter, 100
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi XL, low(table_of_sorted_numbers_alg1)
    ldi XH, high(table_of_sorted_numbers_alg1)
loop_c1:
    ld temp, Z+
    st X+, temp
    dec counter
    brne loop_c1
    ret

;  BUBBLE SORT 
sort_bubble:
    ldi n_pasadas, 100
b_ext:
    ldi ZL, low(table_of_sorted_numbers_alg1)
    ldi ZH, high(table_of_sorted_numbers_alg1)
    ldi counter, 99
b_int:
    ld dato1, Z+
    ld dato2, Z
    cp dato2, dato1
    brge no_swap
    st Z, dato1
    st -Z, dato2
    ld temp, Z+
no_swap:
    dec counter
    brne b_int
    dec n_pasadas
    brne b_ext
    ret