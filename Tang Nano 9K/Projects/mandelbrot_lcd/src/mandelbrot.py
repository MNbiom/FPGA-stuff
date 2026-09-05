import pygame
import time

WIDTH = 240
HEIGHT = 135
PIXEL_SIZE = 5
SCREEN_WIDTH = PIXEL_SIZE * WIDTH
SCREEN_HEIGHT = PIXEL_SIZE * HEIGHT
BORDER = 1 #-1 = no border

screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))

def clear_screen():
    pygame.draw.rect(screen, (0, 0, 0), (0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))

def draw_pixel(x, y, r=255, g=255, b=255):
    rx = x*PIXEL_SIZE
    ry = (SCREEN_HEIGHT-PIXEL_SIZE)-(y*PIXEL_SIZE)
    pygame.draw.rect(screen, (r, g, b), (rx, ry, PIXEL_SIZE, PIXEL_SIZE))
    pygame.draw.rect(screen, (0, 0, 0), (rx, ry, PIXEL_SIZE, PIXEL_SIZE),BORDER)

def q8_8(x):
    return int(x*256)/256

REAL_START = -3
REAL_END = 1
IMAGINARY_START = -1.125
IMAGINARY_END = 1.125

ITERACTIONS = 31

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                pygame.quit()
                exit()

    #clear_screen()
    for y in reversed(range(0, HEIGHT)):
        for x in reversed(range(0, WIDTH)):
            #cr = REAL_START + (x/WIDTH) * (REAL_END - REAL_START)
            #ci = IMAGINARY_START + (y/HEIGHT) * (IMAGINARY_END - IMAGINARY_START)
            cr = q8_8(REAL_START + q8_8(x/WIDTH) * (REAL_END - REAL_START))
            ci = q8_8(IMAGINARY_START + q8_8(y/HEIGHT) * (IMAGINARY_END - IMAGINARY_START))

            # cr = -1.5 + (x/32)
            # ci = -1 + (y/32)

            n = ITERACTIONS
            zr = 0
            zi = 0
            while q8_8((zr*zr)+(zi*zi))<4 and n!=0:
                zr2 = q8_8((zr*zr)-(zi*zi))
                zi2 = q8_8((zr*zi)*2)
                zr = q8_8(zr2 + cr)
                zi = q8_8(zi2 + ci)
                n-=1
            if n == 0:
                draw_pixel(x, y, 255, 255, 255)
            # draw_pixel(x, y, int(255*(n/ITERACTIONS)), int(255*(n/ITERACTIONS)), int(255*(n/ITERACTIONS)))
        pygame.display.update()