
.ifndef data_s
.equ data_s, 0x00000000

.data

bufferSecundario: .skip BYTES_FRAMEBUFFER

// A mayor número mas lento va la animación
delay: .dword 0xFFFFF1 

semilla: .dword 0xf924eefbee3f

blackColor: .word 0x000000
whiteColor: .word 0xFFFFFF

// Variable para guardar la dirección de memoria del comienzo del frame buffer
dir_frameBuffer: .dword 0

.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGH, 480
.equ SCREEN_PIXELS, SCREEN_WIDTH * SCREEN_HEIGH
.equ BYTES_PER_PIXEL, 4
.equ BITS_PER_PIXEL, 8 * BYTES_PER_PIXEL
.equ BYTES_FRAMEBUFFER, SCREEN_PIXELS * BYTES_PER_PIXEL
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.equ key_W, 0x2
.equ key_A, 0x4
.equ key_S, 0x8
.equ key_D, 0x10
.equ key_SPACE, 0x20

.endif
