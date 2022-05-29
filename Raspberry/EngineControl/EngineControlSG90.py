import RPi.GPIO as GPIO
import time
from paho.mqtt import client as mqtt_client

# der Servomotor wurde an den GPIO Pin 18 angeschlossen
servo_PIN = 18 
# moegliche Servopositionen fuer dieses Beispiel
servo_positions = [2.5,12.5]

GPIO.setwarnings(False) 
GPIO.setmode(GPIO.BCM)
# setzen des GPIO Pins als Ausgang
GPIO.setup(servo_PIN, GPIO.OUT)

# Funktion zum setzen eines Winkels
# als Parameter wird die Position erwartet
def set_servo_cycle(p, position):
    p.ChangeDutyCycle(position)
    # eine Pause von 0,5 Sekunden
    time.sleep(0.5)

def set_position(position):
    print(position)   
    new_position = servo_positions[0] if position == 'close' else servo_positions[1]
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO als PWM mit 50Hz
        p.start(servo_positions[0]) # Initialisierung mit dem ersten Wert aus unserer Liste
        set_servo_cycle(p, new_position)
    # wenn das Script auf dem Terminal / der Konsole abgebrochen wird, dann...
    except KeyboardInterrupt:
        p.stop()
        # alle Pins zuruecksetzen
        GPIO.cleanup()
  
def test_servo():
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO als PWM mit 50Hz
        p.start(servo_positions[0]) # Initialisierung mit dem ersten Wert aus unserer Liste
        # eine Endlos Schleife
        for pos in servo_positions:
          # setzen der Servopostion
          set_servo_cycle(p, pos)
          # durchlaufen der Liste  in umgekehrter Reihenfolge
        for pos in reversed(servo_positions):
          set_servo_cycle(p, pos)
          
    # wenn das Script auf dem Terminal / der Konsole abgebrochen wird, dann...
    except KeyboardInterrupt:
        p.stop()
        # alle Pins zuruecksetzen
        GPIO.cleanup()
        




