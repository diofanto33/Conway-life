.ifndef seed_s
.equ seed_s, 0x00000000

.include "data.s"
.include "utils.s"
.include "random.s"

/*
 * @brief: Draw a glider with an initial direction in 
 *    the bottom left corner
 *
 * @param: x3 - x coordinate of the glider 
 * @param: x4 - y coordinate of the glider 
 * @use: draw_chunk2 function and w12 register to color
 * @return: void
 * @saveStack: x3, x4, x30 
 * @glider: https://conwaylife.com/wiki/Glider 
 */

seed_glider:
    sub sp, sp, #24
    str x4, [sp, #16]
    str x3, [sp, #8]
    str x30, [sp]
        
    ldr w12, whiteColor

    add x3, x3, #40
    add x4, x4, #40
    bl draw_chunk2
    add x3, x3, #8
    add x4, x4, #8
    bl draw_chunk2
    add x4, x4, #8
    bl draw_chunk2
    sub x3, x3, #8
    bl draw_chunk2
    sub x3, x3, #8
    bl draw_chunk2

    ldr x4, [sp, #16]
    ldr x3, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #24
    br x30

/* @brief: The random_seed function generates a random pattern
 *    on the screen using the colors black and white. It relies
 *    on the numeroAleatorio function provided by the random.s 
 *    module to obtain a random number. 
 *
 *    The specific pattern is determined by the constant semilla,
 *    which is defined in data.s.
 *
 *    The random_seed function takes a random number returned by the 
 *    numeroAleatorio function and applies the AND logic operator to 
 *    obtain a number between 1 and 2. This number is then compared to 2.
 *    If the number is equal to 2, the function sets the color to black;
 *    otherwise, it sets the color to white. Finally, the draw_chunk2 
 *    function is used to draw an 8x8 pixel square on the screen.
 * 
 *    You can modify the constant 'semilla' defined in data.s to change 
 *    the animation.
 * 
 * @param: none
 * @use: draw_chunk2, numeroAleatorio, x3, x4, x5, x6 and w12 registers
 * @saveStack: x3, x4, x5, x6, x30
 * @return: void
 */ 

random_seed:
    sub sp, sp, #40
    str x6, [sp, #32]
    str x5, [sp, #24]
    str x4, [sp, #16]
    str x3, [sp, #8]
    str x30, [sp]   
    
    mov x3, #0 
    mov x4, #0 
    mov x6, #60
random_seed_loop1:
    mov x5, #80
random_seed_loop0:
    bl numeroAleatorio
    and x1, x1, #2
    cmp x1, #2
    b.eq random_seed_set_black_color 
    bl random_seed_set_white_color
random_seed_back_to_work:
    bl draw_chunk2
    add x3, x3, #8
    sub x5, x5, #1
    cbnz x5, random_seed_loop0
    mov x3, #0 
    add x4, x4, #8
    sub x6, x6, #1
    cbnz x6, random_seed_loop1
    bl random_seed_end

random_seed_set_white_color:
    ldr w12, whiteColor
    b random_seed_back_to_work 

random_seed_set_black_color:
    ldr w12, blackColor
    b random_seed_back_to_work 

random_seed_end:
    ldr x6, [sp, #32]
    ldr x5, [sp, #24]
    ldr x4, [sp, #16]
    ldr x3, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #40
    br x30

.endif
