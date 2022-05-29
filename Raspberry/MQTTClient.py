from paho.mqtt import client as mqtt_client
from dotenv import load_dotenv
from Cryptography.ChaCha20 import encrypt_cipher_text
import json
import os
from EngineControl.EngineControlSG90 import test_servo, set_position
import json
import threading

load_dotenv()

raspberry_ip_address = os.getenv('IP_ADDRESS')
print(raspberry_ip_address)
mosquitto_port = int(os.getenv('PORT'))
  
position_topic = os.getenv('POSITION_TOPIC')
status_topic = os.getenv('STAUTS_TOPIC')


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(position_topic)
    print(position_topic)
    client.subscribe('engine_control')
    client.publish(status_topic, payload='close', qos=1, retain=True)

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, message):
    print("recieved message")
    recievedJson = json.loads(message.payload)
    if (message.topic == "engine_control"):
        public_key = recievedJson['publicKey']
        payload = recievedJson['payload']
        message = encrypt_cipher_text(cipher_stirng=payload, public_key=public_key)
        new_position_json = json.loads(message)
        set_position(new_position_json['position'])
        client.publish(status_topic, payload=new_position_json['position'], qos=1, retain=True)

client = mqtt_client.Client(client_id="")
#client = mqtt_client.Client(client_id="engine_control_sg90", clean_session=True, userdata=None, protocol=MQTTv5, transport="tcp")

client.on_connect = on_connect
client.on_message = on_message


client.connect(raspberry_ip_address, mosquitto_port, 60)

#test motor
test_servo()


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client.loop_forever()

