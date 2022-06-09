# Rasperberry Pi 
## Step-engine control
For each step there must run one step-engine control which can be found in `./StepEngineControl`
## MQTT Broker - Mosquitto

A detailed description of the Mosquitto MQTT Broker ca be found under: https://mosquitto.org/

### Installation
```
sudo apt install mosquitto
```
### Helpful commands
```
sudo systemctl start mosquitto    # Start
sudo systemctl stop mosquitto     # Stop
sudo systemctl restart mosquitto  # Restart
sudo systemctl disable mosquitto  # Autostart deactivate
sudo systemctl enable mosquitto   # Autostart activate
```
### Test client installation
Using Mosquitto Test Clients it is possible to send and receive messages by executing only one line of code. 

```
sudo apt install mosquitto-clients # installation of the test clients
```
Publish a Message on topic "set_position" for step_id = 1 with a test client
```
mosquitto_pub -d -t arena2036/rolling_chassis/1/set_position -m "Test" 
```

Subscribe to the topic "set_position"
```
mosquitto_sub -d -t arena2036/rolling_chassis/1/set_position
```

## Messages for set_position
Below are executable open and close messages that can be used to test the function of the step MQTT client. 

1. Close-Message
```
"{"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6Ik5pa2xhcyJ9.Ylkw5vN_vWO9y7fDtBEZ6ozA4QosH7u_TtGj6kvwE64","position": "close"}"
```
**Encrypted**
```
"{"payload":"DWHG0rFAn6Equ4DIl0eHY\/E8fnlA\/+fD1YDoS34sDC43clx3BI7honKqN4U5m4s7nyA5DBqWYsIfw0So2frbKb5Ma8vKTVVOKJjIi23g0ApA+j4rz49MT4RvwuRVDMYg94ykM5VgphgHe\/i8QDvD9CjihBsazC17z3HiNz4fG856nGr5ISGuthaIme3SZfuwBoqxoQPT+kK+yH7WQzKaeR3M97xlOhksTQ8b0A==" "publicKey":"GsLXC3jlMJ2KhoalVXDNee+jGSVnmO9cG0rb+qGQIRc="}"
```
2. Open Message
```
"{"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6Ik5pa2xhcyJ9.Ylkw5vN_vWO9y7fDtBEZ6ozA4QosH7u_TtGj6kvwE64","position": "open"}"
```
**Encrypted**
```
"{"payload": "wffpHc\/+uuLHpLUE1cIaBxT3dHDk3PjJDa\/jgVQu35MAASicRBCVjp9zjyfRMqg1us4ZaczC8sC7TRL1bohTaQMKEMzscJl1B\/k9NQKhRzN7sa+ERbuBfuqYUsAvf5uCVKtnhI57RN2BEBMjHBZHE91gk8sBmENIBCygJRwhga\/\/6\/hUikl2icDBc7u3qLofg\/1JJmG0ickGJ0pItZW1UTI3WlAHVA\/WPmGV","publicKey":"3N8UZCxRrvn44MITRT9n8rCjWHpIOr6fgBVViYC1NkE="}"
```