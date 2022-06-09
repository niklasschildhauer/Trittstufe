# Step-engine control
So that a step can be controlled by the app, an MQTT client must run for each step. This MQTT client sends the current status of the step to the topic `status` and receives the messages for the topic `set_position`.

When receiving, the message is first decrypted and then it is verified that the user is authorized to extend the step. After that the engine control is called, which sets the new position. 

For test purposes the script `EngineControlSG90.py` was created, which controls a small servo motor. **This file must be replaced by the real engine control script.**

## Packages
Paho MQTT Client
```
pip install paho-mqtt
```
To read .env files
```
pip install python-dotenv
```

For the generation and validation of the JWT tokens
```
pip install pyjwt
```

For decoding the `set_position` messages 
```
pip install cryptography
pip install PyCryptodome
```

## Starting Point
To start the engine control the `MQTTClient.py` script has to be executed
```
python MQTTClient.py
```

## MQTT Client
The script `MQTTClient.py` uses the package `paho-mqtt` to act as MQTT client. It uses the `.env`-file to read all relevant information like the IP-Adresse and Port-number of the MQTT Broker, as well as the private and public key of the Client itself and the important **step_id**. This Integer indicates which step it is. It ca be either:
 - step_id = 1 (right) or 
 - step_id = 2 (left.

If there is a change in the backend data model, it has to be changed in the env file as well.

## Engine control script
The current test `EngineControlSG90.py` script can be found under `./EngineControl`.
The `MQTTClient.py` script uses the following methods to control the step.

With the following a new position is set. The position is a string which can be either "open" or "close".
```
def set_position(position):
```
The following method should return the current status of the step in form of a JSON-object.
```
def create_status_json(): 
```
The following method is used to test the functionality of the engine when the MQTT client is started. 
```
def test_servo():
```


