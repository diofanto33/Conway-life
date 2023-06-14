	
.include "data.s"
.include "utils.s"
.include "game_life.s"
.include "seed.s"
.globl main
   
.equ SCREEN_PIXELS_div_2_menos_1, SCREEN_PIXELS/2 - 1
/* Last index considering the elements as dword */ 
screen_pixels_div_2_menos_1: .dword SCREEN_PIXELS_div_2_menos_1

/*
 * @brief: Copy everything from the secondary buffer to the frame buffer.
 *  Executed once per frame.
 *  The frame buffer address must be provided in dir_frameBuffer 
 * 
 * @param: x0 = Secondary buffer address 
 * @return: None
 * @saveStack: None
 * @modifies: x9, x10, x11
 */
update_FB:
    ldr x0, =bufferSecundario        
    ldr x9, dir_frameBuffer
    ldr x10, screen_pixels_div_2_menos_1
loop_update_FB:
    cmp x10, #0
    b.lt end_loop_update_FB
    ldr x11, [x0, x10, lsl #3]
    str x11, [x9, x10, lsl #3]
    sub x10, x10, #1
    b loop_update_FB
end_loop_update_FB:
    br lr

main:
    /* save the address of the frame-buffer in x20 */ 
    mov x20, x0

    /* Load the address of the frame buffer into register x1 */  
    adr x1, dir_frameBuffer
    /* store the memory address of the frame-buffer in dir_frameBuffer */
    str x0, [x1]
    
    /* draw the screen of black color */ 
    bl draw_bg_fb2
    
    /* direct the seed */
    mov x3, #40
    mov x4, #40
    /* draw the seed */ 
    bl seed_glider

    /* update the frame-buffer */ 
    bl update_FB

/* start the game of life */ 
game_loop:   
    bl game_life
    bl do_delay 
    bl update_FB
    b game_loop
