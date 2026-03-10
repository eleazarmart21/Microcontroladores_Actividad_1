;
; Código 2.asm
;
; Created: 8/3/2026 16:40:09
; Author : VOSTRO
;


; Replace with your application code
; TÍTULO: Ordenamiento por Selección (Selection Sort)
; AUTOR: Josué Eleazar Santana Martínez, Ramos Ramírez Alberto Carlos, Luna Leyva Azul Desiree
; MICROCONTROLADORES 2859

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
table_of_sorted_numbers_alg2:  .byte 100 ; [cite: 9]

.cseg
.org $0000
    rjmp main

main:
    ldi temp, low(RAMEND)
    out SPL, temp
    ldi temp, high(RAMEND)
    out SPH, temp

    rcall generar_aleatorios  
    rcall copiar_a_alg2
    rcall sort_selection      

fin: 
    rjmp fin

generar_aleatorios:
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi counter, 100
    ldi v_in, $1A
loop_gen2:
    mov temp, v_in
    lsr v_in
    brcc no_xor2
    ldi temp, $1D
    eor v_in, temp
no_xor2:
    st Z+, v_in
    dec counter
    brne loop_gen2
    ret

copiar_a_alg2:
    ldi counter, 100
    ldi ZL, low(table_of_unsorted_numbers)
    ldi ZH, high(table_of_unsorted_numbers)
    ldi XL, low(table_of_sorted_numbers_alg2)
    ldi XH, high(table_of_sorted_numbers_alg2)
loop_c2:
    ld temp, Z+
    st X+, temp
    dec counter
    brne loop_c2
    ret

; ALGORITMO 2: SELECTION SORT 
sort_selection:
    ldi XL, low(table_of_sorted_numbers_alg2)
    ldi XH, high(table_of_sorted_numbers_alg2)
    ldi n_pasadas, 100
s_base:
    ld dato1, X
    mov ZL, XL
    mov ZH, XH
    adiw ZL, 1
    mov r24, XL
    mov r25, XH
    mov counter, n_pasadas
    dec counter
    breq s_done
s_min:
    ld dato2, Z+
    cp dato2, dato1
    brsh s_next
    mov dato1, dato2
    mov r24, ZL
    subi r24, 1
    mov r25, ZH
s_next:
    dec counter
    brne s_min
    ld temp, X
    st X, dato1
    mov ZL, r24
    mov ZH, r25
    st Z, temp
s_done:
    adiw XL, 1
    dec n_pasadas
    brne s_base
    ret
