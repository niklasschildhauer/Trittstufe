from paho.mqtt import client as mqtt_client
from dotenv import load_dotenv
from Cryptography.ChaCha20 import encrypt_cipher_text
import os

load_dotenv()

raspberry_ip_address = os.getenv('IP_ADDRESS')
mosquitto_port = os.getenv('PORT')
  
mqtt_topic = "engine_control"

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(mqtt_topic)

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, message):
    print(message.topic+" "+str(message.payload))
    json = json.loads(message.payload)

    public_key = json['publicKey']
    payload = json['payload']

    print("test")
    print(public_key)
    print(payload)
    print("test")

    message = encrypt_cipher_text(cipher_stirng=payload, public_key=public_key)
    print("----message----")
    print(message)
    print("----message----")

    #startServoCycle()

client = mqtt_client.Client(client_id="engine_control_sg90")
client.on_connect = on_connect
client.on_message = on_message

client.connect(raspberry_ip_address, mosquitto_port, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
