#!/usr/bin/python
 
import RPi.GPIO as GPIO
import time
import subprocess, os
import signal
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
RearView_Switch = 24  # Your GPIO pin here
GPIO.setup(RearView_Switch,GPIO.IN, pull_up_down=GPIO.PUD_UP)
 
try:
    
   run = 0     
   while True :
        time.sleep(0.1)
        if GPIO.input(RearView_Switch)==0 and run == 0:
            rpistr = "raspivid -t 0 -vf -w 1280 -h 720 -fps 30"  # Tweak for your camera setup. 
            p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
            run = 1
            while GPIO.input(RearView_Switch)==0:
                    time.sleep(0.1)
        if GPIO.input(RearView_Switch)==1 and run == 1:
            run = 0
            os.killpg(p.pid, signal.SIGTERM)
            while GPIO.input(RearView_Switch)==1:
                    time.sleep(0.1)
 
except KeyboardInterrupt:
  GPIO.cleanup()