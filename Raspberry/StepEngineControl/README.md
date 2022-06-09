# Step-engine control
So that a step can be controlled by the app, an MQTT client must run for each step. This MQTT client sends the current status of the step to the topic `status` and receives the messages for the topic `set_position`.

When receiving, the message is first decrypted and then it is verified that the user is authorized to extend the step. After that the engine control is called, which sets the new position. 

For test purposes the script `EngineControlSG90.py` was created, which controls a small servo motor. **This file must be replaced by the real engine control script.**

## Engine control script