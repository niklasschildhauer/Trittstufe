import RPi.GPIO as GPIO
import time
from paho.mqtt import client as mqtt_client

# der Servomotor wurde an den GPIO Pin 18 angeschlossen
servoPIN = 18 
# moegliche Servopositionen fuer dieses Beispiel
servoPositions = [2.5,5,7.5,10,12.5]
mqtt_topic = "engine_control"
mosquitto_port = 1883
raspberry_ip_address = "192.168.0.65"

# Funktion zum setzen eines Winkels
# als Parameter wird die Position erwartet
def setServoCycle(p, position):
    p.ChangeDutyCycle(position)
    # eine Pause von 0,5 Sekunden
    time.sleep(0.5)
  
def startServoCycle():
    try:
        # damit wir den GPIO Pin ueber die Nummer referenzieren koennen
        GPIO.setmode(GPIO.BCM)
        # setzen des GPIO Pins als Ausgang
        GPIO.setup(servoPIN, GPIO.OUT)
        p = GPIO.PWM(servoPIN, 50) # GPIO als PWM mit 50Hz
        p.start(servoPositions[0]) # Initialisierung mit dem ersten Wert aus unserer Liste
        # eine Endlos Schleife
        for pos in servoPositions:
          # setzen der Servopostion
          setServoCycle(p, pos)
          # durchlaufen der Liste  in umgekehrter Reihenfolge
        for pos in reversed(servoPositions):
          setServoCycle(p, pos)
          
    # wenn das Script auf dem Terminal / der Konsole abgebrochen wird, dann...
    except KeyboardInterrupt:
        p.stop()
        # alle Pins zuruecksetzen
        GPIO.cleanup()

  
  
  
  
  
  
# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(mqtt_topic)

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))
    startServoCycle()

client = mqtt_client.Client(client_id="engine_control_sg90")
client.on_connect = on_connect
client.on_message = on_message

client.connect(raspberry_ip_address, mosquitto_port, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()



