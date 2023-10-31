; Autor reseni: Dominik Borek xborek12
; Pocet cyklu k serazeni puvodniho retezce: 2820
; Pocet cyklu razeni sestupne serazeneho retezce: 2868
; Pocet cyklu razeni vzestupne serazeneho retezce: 2723
; Pocet cyklu razeni retezce s vasim loginem: 604
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
login:          .asciiz "xborek12"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        daddi   r4, r0, login  ; Nastaví r4 na začátek textového řetězce v login
        lbu     r6, 0(r4)      ; Načte první znak textového řetězce

get_string_length:
        beqz    r6, end_get_string_length  ; Pokud je znak nulový (konec řetězce), přejde na konec
        daddi   r5, r5, 1        ; Inkrementuje délku textového řetězce v r5
        daddi   r4, r4, 1        ; Posune ukazatel na další znak
        lbu     r6, 0(r4)        ; Načte další znak textu
        j       get_string_length  ; Skočí zpět na začátek cyklu pro další znak

end_get_string_length:
        daddi   r5, r5, -1      ; Sníží délku o 1 (protože jsme začali na nulovém indexu)
        daddi   r4, r0, login    ; Resetuje ukazatel zpět na začátek textového řetězce v login
        jal     sort_asc         ; Zavolá funkci pro seřazení textu vzestupně
        
        daddi   r4, r0, login    ; Resetuje ukazatel na začátek textového řetězce
        jal     print_string     ; Vypíše seřazený řetězec
        
        syscall 0                ; Halt

sort_asc: ; adresa řetězce se očekává v r4, délka řetězce v r5 
        daddi   r6, r0, 1       ; Inicializuje r6 na hodnotu 1 (pozice v řetězci)

outer_loop_sort_asc:
        daddi   r7, r0, 0       ; Inicializuje r7 na hodnotu 0 (pozice v řetězci)

inner_loop_sort_asc:
        lbu     r8, 0(r4)        ; Načte první znak
        lbu     r9, 1(r4)        ; Načte druhý znak
        beqz    r9, end_sort_asc  ; Pokud je druhý znak nulový (konec řetězce), skončí
        slt     r10, r9, r8      ; Porovná r8 a r9, výsledek v r10 (1, pokud r9 < r8)
        beqz    r10, no_swap_sort_asc  ; Pokud r9 >= r8, neprovádí výměnu
        sb      r9, 0(r4)        ; Prohodí r9 s r8 v textovém řetězci
        sb      r8, 1(r4)
no_swap_sort_asc:
        daddi   r4, r4, 1        ; Posune ukazatel na další pozici v řetězci
        daddi   r7, r7, 1        ; Inkrementuje pozici v řetězci
        bne     r7, r5, inner_loop_sort_asc  ; Pokud nebyla projita celá délka řetězce, opakuje vnitřní smyčku
        daddi   r4, r0, login      ; Resetuje ukazatel na začátek textového řetězce
        daddi   r5, r5, -1        ; Sníží délku o 1 (protože byla dokončena jedna iterace)
        bne     r5, r0, outer_loop_sort_asc  ; Pokud délka řetězce není 0, pokračuje v další iteraci
end_sort_asc:
        jr r31  ; Konec funkce
        
print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
