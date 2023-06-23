.ifndef random_s
.equ random_s, 0x00000000

.include "data.s"


/* nuevoNumeroAleatorio:
    Parámetro:
        x1 = Número de entrada
    Crea un número aleatorio a partir del valor en x1, y lo guarda en x1.
    A partir de la misma entrada se obtiene la misma salida, pero a cualquier pequeño cambio en la
    entrada, la salida cambia completamente.
    Utiliza x9.
    Modifica x1.
 */
/* Detalles del funcionamiento: https://en.wikipedia.org/wiki/Linear-feedback_shift_register */
nuevoNumeroAleatorio:
    cmp x1, #0
    csinc x1, x1, xzr, ne // x1 = x1 != 0 ? x1 : x1 + 1
    // Si x1 = 0 el algoritmo da siempre en 0, así que en ese caso lo cambio a 1
    eor x9, x1, x1, lsr #2
    eor x9, x9, x1, lsr #3
    eor x9, x9, x1, lsr #5
    lsl x9, x9, #15
    orr x1, x9, x1, lsr #1

    br lr // return
//

/* numeroAleatorio:
    Pone un número aleatorio (según semilla) en x1.
    Utiliza x9.
 */
/* Detalles del funcionamiento:
    Utiliza nuevoNumeroAleatorio para obtener un nuevo aleatorio, el cuál lo devuelve, y lo guarda en semilla.
 */
numeroAleatorio:
    sub sp, sp, #8 // Guardo el puntero de retorno en el stack
    stur lr, [sp]

    ldr x1, semilla // Pongo en x1 la semilla actual
    bl nuevoNumeroAleatorio // Pongo en x1 un nuevo número aleatorio
    adr x9, semilla
    str x1, [x9] // Actualizo la semilla

    ldur lr, [sp] // Recupero el puntero de retorno del stack
    add sp, sp, #8
    br lr // return

.endif
