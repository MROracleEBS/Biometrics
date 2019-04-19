import time
import random
import RPi.GPIO as MYGPIO

MYGPIO.setmode (MYGPIO.BOARD)

MYGPIO.setup(3,MYGPIO.OUT)
MYGPIO.setup(13,MYGPIO.OUT)
MYGPIO.setup(12,MYGPIO.IN)

print('Reaction time game')
print('Project 4')
print('')
print('')

MYGPIO.output(3,MYGPIO.HIGH)
MYGPIO.output(13,MYGPIO.HIGH)
time.sleep(2)
MYGPIO.output(3,MYGPIO.LOW)
MYGPIO.output(13,MYGPIO.LOW)

print('The green light will stay on for a random amount of time between 1 to 10')
print('It will then swap to red light')
print('As soon as it changes hit the switch')
print('We start in 5 seconds')
time.sleep(5)

MYGPIO.output(3,MYGPIO.HIGH)
r = random.randint(1,10)
time.sleep(r)

MYGPIO.output(3,MYGPIO.LOW)
MYGPIO.output(13,MYGPIO.HIGH)
start =  time.time()

try:
    while True:
        if(MYGPIO.input(12)==1):
            end =  time.time()
            print('You pressed the button')
            elapsed = end - start
            print(' and it took: ')
            print(round(elapsed , 2))
            print(' Try to beat that next time.')
            MYGPIO.output(3,MYGPIO.LOW)
            MYGPIO.output(13,MYGPIO.LOW)
            MYGPIO.cleanup()
            break
        else:
            MYGPIO.output(3,MYGPIO.LOW)
            MYGPIO.output(13,MYGPIO.HIGH)
            
except KeyboardInterrupt:
    print('GAME OVER')
