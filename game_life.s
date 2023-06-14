/* author: diofanto33
 * file  : game_life.s 
 * date  : summer 2022 
 * time  : 04:49:37 AM
 *
 * This file implements the game of life in assembly language
 */

.ifndef game_life_s
.equ game_life_s, 0x00000

.include "data.s"
.include "utils.s"

/*
 * @brief: The check_life_status function increments register x6 
 *  by one if and only if the pixel pointed to by x0 is white, or
 *  equivalently, increments the counter if the cell is alive. 
 *
 *  It is important to note that the information is obtained by 
 *  observing the main FrameBuffer, and it is done in a circular
 *  manner (toroidal matrix) using the map function.
 * 
 * @param: (x3, x4) initial address in the upper left corner of the chunk 
 * @param: x6 counter
 * @return: x6 
 * @uses: map
 * @saveStack: x7 and x30
 */ 

check_life_status:
    sub sp, sp, #16
    str x7, [sp, #8]
    str x30, [sp]

    bl map    
    ldurb w7, [x0]
    cbnz w7, increase_x6
    ldr x7, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #16
    br x30 

increase_x6:
    add x6, x6, #1
    ldr x7, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #16
    br x30

/*
 * @brief: The rules procedure applies the rules known as B3/S23,
 *  where "B3" stands for "birth with three neighbors" and "S23" 
 *  stands for "survive with two or three neighbors," as defined 
 *  by Conway in the game of life.

 *  Utilize check_life_status to count neighbors.
 *  Use draw_chunk2 to paint the next generation in the Secondary Buffer.
 *  Apply map when there is no permutation (i.e. when the cell should 
 *  remain in the same state) to extract the color from the main FrameBuffer
 *  and assign it to w12, then make the draw_chunk2 call.
 *
 * @param: (x3, x4) initial address in the upper left corner of the chunk 
 * @return: none
 * @saveStack: x3, x4, x0, x30
 * @uses: check_life_status, draw_chunk2, map
 * @modifies: x6 
 */

rules:
    sub sp, sp, #32
    str x3, [sp, #24]   
    str x4, [sp, #16]
    str x0, [sp, #8]
    str x30, [sp]

    mov x6, #0         
    add x3, x3, #8        /* right (1) */
    bl check_life_status   
    sub x4, x4, #8        /* up (2)    */ 
    bl check_life_status          
    sub x3, x3, #8        /* left (3)  */ 
    bl check_life_status
    sub x3, x3, #8        /* left (4)  */ 
    bl check_life_status
    add x4, x4, #8        /* down (5)  */ 
    bl check_life_status
    add x4, x4, #8        /* down (6)  */ 
    bl check_life_status  
    add x3, x3, #8        /* right (7) */ 
    bl check_life_status
    add x3, x3, #8        /* right (8) */  
    bl check_life_status
   
    cmp x6, #4
    b.ge dead
    cmp x6, #0
    b.eq dead
    cmp x6, #1
    b.eq dead
    cmp x6, #3
    b.eq born
    cmp x6, #2
    b.eq keep_state
    bl end_rule

end_rule:    
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    ldr x0, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #32
    br x30

keep_state:
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    bl map
    ldr x12, [x0]
    bl draw_chunk2
    bl end_rule

born:
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    ldr w12, whiteColor
    bl draw_chunk2
    bl end_rule

dead:
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    ldr w12, blackColor
    bl draw_chunk2
    bl end_rule

/* 
 * @brief: The game_life procedure iterates over the entire 
 *  array in 8x8 chunks, specifically 80 chunks wide and 60 
 *  chunks tall, applying the rules procedure to each chunk.
 *
 *  Always observe the main FrameBuffer using the rules procedure.
 *
 * @param: none
 * @return: none 
 * @saveStack: x1, x2, x30 
 * @uses: rules
 * @modifies: none
 */ 

game_life:
    sub sp, sp, #24
    str x2, [sp, #16]
    str x1, [sp, #8]
    str x30, [sp]

    mov x3, 0x0
    mov x4, 0x0
    mov x0, x20
    mov x2, #60
game_life_loop1:
    mov x1, #80
game_life_loop2:
    bl rules
    add x3, x3, #8
    sub x1, x1, #1
    cbnz x1, game_life_loop2
    add x4, x4, #8
    mov x3, 0x0
    sub x2, x2, #1
    cbnz x2, game_life_loop1
    
    ldr x2, [sp, #16]
    ldr x1, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #24
    br x30


.endif

