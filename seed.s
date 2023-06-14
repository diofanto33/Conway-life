.ifndef seed_s
.equ seed_s, 0x00000000

.include "data.s"
.include "utils.s"

/*
 * @brief: Draw a glider with an initial direction in 
 *         the bottom left corner
 *
 * @param: x3 - x coordinate of the glider 
 * @param: x4 - y coordinate of the glider 
 *
 * @use: draw_chunk2 function and w12 register to color
 *
 * @return: void
 *
 * @saveStack: x3, x4, x30 
 * 
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


.endif
