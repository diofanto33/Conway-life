.ifndef utils_s
.equ utils_s, 0

.include "data.s"

/*  @brief:
 *  The module_x function computes the remainder of the 
 *  division between x3 and 640 using the formula 
 *  mod(a, b) = a - b * (a/b), where (a/b) represents the 
 *  floor division
 *
 *  @param: x3 
 *  @saveStack: x1, x5 and x30
 *  @return: x3 := mod(x3, 640)
 */

module_x:
    sub sp, sp, #24
    str x5, [sp, #16]
    str x1, [sp, #8]
    str x30, [sp]

    mov x1, #640
    add x3, x3, x1
    udiv x5, x3, x1
    msub x3, x5, x1, x3
    bl end_module_x

end_module_x:
    ldr x5, [sp, #16]
    ldr x1, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #24
    br x30

/*  @brief:
 *  The module_x function computes the remainder of the 
 *  division between x4 and 480 using the formula 
 *  mod(a, b) = a - b * (a/b), where (a/b) represents the 
 *  floor division
 *
 *  @param: x4 
 *  @saveStack: x1, x5 and x30
 *  @return: x3 := mod(x4, 480)
 */

module_y:
    sub sp, sp, #24
    str x5, [sp, #16]
    str x1, [sp, #8]
    str x30, [sp]

    mov x1, #480
    add x4, x4, x1            
    udiv x5, x4, x1           
    msub x4, x5, x1, x4        
    bl end_module_y

end_module_y:
    ldr x5, [sp, #16]
    ldr x1, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #24
    br x30

/*
 *  @brief: The map procedure assigns the memory address of
 *  pixel (x, y) to x0. Before performing the mapping, 
 *  it calculates mod(x3, 640) and mod(x4, 480) using the 
 *  module_x and module_y functions, respectively. 
 *  This defines the array as a toroidal matrix
 *  
 *  @param: x3 Xcoordinate of the pixel 
 *  @param: x4 Ycoordinate of the pixel
 *  @saveStack: x30
 *  @return: x0 := address of pixel (x3, x4) in the main FrameBuffer
 *  @uses: module_x, module_y
 *  @modifies: x21, x15
 *  @toroidal: array[ x % size_x,  y % size_ y]
 *  https://stackoverflow.com/questions/8631238/how-to-make-a-toroidal-array
 */

map:
    sub sp, sp, #8    
    str x30, [sp]
    
    bl module_x
    bl module_y

    mov x21, #4               
    mov x0, x20               
    mov x15, 2560              
    madd x0, x15, x4, x0 	    
    madd x0, x21, x3, x0     

    ldr x30, [sp]
    add sp, sp, #8
    br x30

/*
 * @brief: The map2 procedure assigns the memory address
 * of pixel (x, y) from the SecondaryBuffer to x0
 * 
 * @param: x3 Xcoordinate of the pixel
 * @param: x4 Ycoordinate of the pixel
 * @saveStack: x30
 * @modfies: x21 and x15 
 * @return: x0 := address of pixel (x3, x4) in the SecondaryBuffer
 *
 */

map2:
    sub sp, sp, #8
    stur x30, [sp]

    mov x21, #4
    ldr x0, =bufferSecundario
    mov x15, 2560              
    madd x0, x15, x4, x0       
    madd x0, x21, x3, x0       

    ldur x30, [sp]
    add sp, sp, #8
    br x30

/*
 * @brief: The draw_chunk2 procedure draws a block of 8x8 px 
 * in the SecondaryBuffer, starting with (x3, x4) in the upper
 * left corner.
 *
 * @param: x3 Xcoordinate of the pixel 
 * @param: x4 Ycoordinate of the pixel
 * @param: w12 Color of the pixel 
 * @saveStack: x30, x2, x3, x4 and x0 
 * @uses: map2 
 * @modifies: x8 and x9 
 * @return: void
 *
 */ 

draw_chunk2:
    sub sp, sp, #40
    str x2, [sp, #32]
    str x3, [sp, #24]
    str x4, [sp, #16]
    str x0, [sp, #8]
    str x30, [sp]

    bl map2
    mov x2, #8
draw_chunk2_loop1:
    mov x8, #8
draw_chunk2_loop2:
    str w12, [x0]
    add x0, x0, #4
    sub x8, x8, #1
    cbnz x8, draw_chunk2_loop2
    add x4, x4, 0x1
    bl map2
    sub x2, x2, #1
    cbnz x2, draw_chunk2_loop1

    ldr x2, [sp, #32]
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    ldr x0, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #40
    br x30

/*
 * @brief: The doDelay procedure creates a large loop to 
 * create a delay. The delay time depends on the delay constant
 * 
 * @param: delay <- The delay constant is defined in data.s
 * @saveStack: none 
 * @modifies: x9 
 * @return: void
 */

do_delay:
    ldr x9, delay
loop_do_delay:
    subs x9, x9, 1
    b.ne loop_do_delay    
    br x30 

/*
 * @brief: The draw_bg_fb2 procedure paints the entire array
 *  of the SecondaryBuffer with the black color 
 * 
 * @param: none 
 * @saveStack: x30  
 * @modifies: x1, x2 and w12
 * @return: void
 * @uses: draw_chunk2
 * 
 */

draw_bg_fb2:
    sub sp, sp, #8
    str x30, [sp]

    ldr w12, blackColor
    ldr x0, =bufferSecundario
    mov x2, SCREEN_HEIGH 
loop_fb1:
    mov x1, SCREEN_WIDTH        
loop_fb0:
    stur w12, [x0]      
    add x0, x0, #4    
    sub x1, x1, #1    
    cbnz x1, loop_fb0      
    sub x2, x2, #1    
    cbnz x2, loop_fb1      
    
    ldr x30, [sp] 
    add sp, sp, #8
    br x30

.endif

