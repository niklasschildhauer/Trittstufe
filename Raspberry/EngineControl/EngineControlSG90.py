import RPi.GPIO as GPIO
import time
import json
from paho.mqtt import client as mqtt_client
# der Servomotor wurde an den GPIO Pin 18 angeschlossen
servo_PIN = 18 
# moegliche Servopositionen fuer dieses Beispiel
servo_positions = [2.5,12.5]

# damit wir den GPIO Pin ueber die Nummer referenzieren koennen
current_position_left_side = 'close'
current_position_right_side = 'close'


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

def set_position(position, side):
    print(position) 
    if side == 'left':
      return set_left_side_position(position=position)
    elif side == 'right':
      return set_right_side_position(position=position)

def set_left_side_position(position):
    global current_position_left_side
    if current_position_left_side == position:
      return
    new_position = servo_positions[0] if position == 'close' else servo_positions[1]
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO als PWM mit 50Hz
        p.start(servo_positions[0]) # Initialisierung mit dem ersten Wert aus unserer Liste
        set_servo_cycle(p, new_position)
        current_position_left_side = position 
        return True
    # wenn das Script auf dem Terminal / der Konsole abgebrochen wird, dann...
    except KeyboardInterrupt:
        p.stop()
        # alle Pins zuruecksetzen
        GPIO.cleanup()
        return False


def set_right_side_position(position):
    global current_position_right_side
    if current_position_right_side == position:
      return
    new_position = servo_positions[0] if position == 'close' else servo_positions[1]
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO als PWM mit 50Hz
        p.start(servo_positions[0]) # Initialisierung mit dem ersten Wert aus unserer Liste
        set_servo_cycle(p, new_position)
        current_position_right_side = position 
        return True
    # wenn das Script auf dem Terminal / der Konsole abgebrochen wird, dann...
    except KeyboardInterrupt:
        p.stop()
        # alle Pins zuruecksetzen
        GPIO.cleanup()
        return False

def create_status_json(): 
    data = [{"side":"left", "position": current_position_left_side}, {"side":"right", "position": current_position_right_side}]
    return json.dumps(data)

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
        




