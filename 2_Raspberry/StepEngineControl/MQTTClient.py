from turtle import position
from paho.mqtt import client as mqtt_client
from dotenv import load_dotenv
from Cryptography.ChaCha20 import encrypt_cipher_text
import json
import os
from EngineControl.EngineControlSG90 import test_servo, set_position, create_status_json
import json
import threading
from LocalAuthorization import is_token_valid

load_dotenv()

raspberry_ip_address = os.getenv('IP_ADDRESS')
print(raspberry_ip_address)
mosquitto_port = int(os.getenv('PORT'))

domain = os.getenv('DOMAIN')
car_id = os.getenv('CAR_ID')
step_id = os.getenv('STEP_ID')
position_topic = os.getenv('POSITION_TOPIC')
status_topic = os.getenv('STAUTS_TOPIC')


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed
    client.subscribe(f'{domain}/{car_id}/{step_id}/{position_topic}')
    #client.publish(f'{domain}/{car_id}/{step_id}/{status_topic}', 0, 0 , True);

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, message):
    print("recieved message")
    recievedJson = json.loads(message.payload)
    if (message.topic == f'{domain}/{car_id}/{step_id}/{position_topic}'):
        public_key = recievedJson['publicKey']
        payload = recievedJson['payload']
        print("1")
        try:
            print("2")
            message = encrypt_cipher_text(cipher_stirng=payload, public_key=public_key)
            print("3")
            print("Message successfully decrypted")
        except:
            print("Decryption failed")
            return 
        new_position_json = json.loads(message)
        if is_token_valid(new_position_json["token"]):
            new_position = new_position_json['position']
            if new_position != 'unknown':
                print(f'Message is valid. Set new position: {new_position_json["position"]}')
                set_position(position=new_position_json['position'])
            send_status_update()
        else:
            print("Invalid token")

def send_status_update():
    topic = f'{domain}/{car_id}/{step_id}/{status_topic}'
    print(topic)
    client.publish(topic, payload=create_status_json(), qos=1, retain=False)
    print(f"Send status update")

client = mqtt_client.Client(client_id=f"engine_control_{step_id}", clean_session=True)
client.on_connect = on_connect
client.on_message = on_message

client.connect(raspberry_ip_address, mosquitto_port, 20)


test_servo()
send_status_update()

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()

