import time
import RPi.GPIO as MYGPIO

MYGPIO.setmode (MYGPIO.BOARD)
MYGPIO.setup(7,MYGPIO.OUT)
MYGPIO.output(7,MYGPIO.HIGH)
time.sleep(1)

MYGPIO.setup(5,MYGPIO.OUT)
MYGPIO.output(5,MYGPIO.HIGH)
time.sleep(1)

MYGPIO.setup(3,MYGPIO.OUT)
MYGPIO.output(3,MYGPIO.HIGH)
time.sleep(1)

MYGPIO.output(7,MYGPIO.LOW)
time.sleep(1)

MYGPIO.output(5,MYGPIO.LOW)
time.sleep(1)

MYGPIO.output(3,MYGPIO.LOW)
time.sleep(1)

MYGPIO.cleanup()
