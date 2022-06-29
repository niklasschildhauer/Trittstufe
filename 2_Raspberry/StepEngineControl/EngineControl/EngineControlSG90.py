import RPi.GPIO as GPIO
import time
import json

# engine connected to GPIO pin 18
servo_PIN = 18 
servo_positions = [2.5,12.5] # index 0 = close, index 1 = open

# the current position of the step. Initial close
current_position = 'close'

GPIO.setwarnings(False) 
GPIO.setmode(GPIO.BCM)
GPIO.setup(servo_PIN, GPIO.OUT) # set the GPIO pin as output

# private function to set a new position angle
def _set_servo_cycle(p, position):
    p.ChangeDutyCycle(position)
    time.sleep(0.5) # sleep for 0,5 sec after setting a new position

# public function to set a new position. The position parameter can either be 'close' or 'open'
def set_position(position):
    global current_position
    if current_position == position:
      return
    new_position = servo_positions[1] if position == 'open' else servo_positions[0]
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO as PWM with 50Hz
        p.start(servo_positions[0])
        _set_servo_cycle(p, new_position)
        current_position = position 
        return True
    # when the script is aborted on the terminal / console
    except KeyboardInterrupt:
        p.stop()
        # reset all pins
        GPIO.cleanup()
        return False

# public function to get the current position of the step
def create_status_json(): 
    data = {"position": current_position}
    print(json.dumps(data))
    return json.dumps(data)

# public function to set the function of the step
def test_servo():
    try:
        p = GPIO.PWM(servo_PIN, 50) # GPIO as PWM with 50Hz
        p.start(servo_positions[0])
        for pos in servo_positions:
          _set_servo_cycle(p, pos)
        for pos in reversed(servo_positions):
          _set_servo_cycle(p, pos)
          
    # when the script is aborted on the terminal / console
    except KeyboardInterrupt:
        p.stop()
        # reset all pins
        GPIO.cleanup()
        




