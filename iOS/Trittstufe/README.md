# Trittstufe - iOS App

## Requirements
To run this App you need an Apple Developer Account with an active Apple Devloper Membership. This is important because an NFC tag reader is used in this project. For this to work the capability `Near Field Communication Tag Reading` must be activated. This project is activated in the HdM account.

## First steps
0. If you don't have CocoaPods installed on your Mac, run the following command:
```
sudo gem install cocoapods
```

1. Run the following command to install the pods

```
pod install
```

2. Open the workspace: `Trittstufe.xcworkspace`
3. Update the Signing of the Target `Trittstufe`

## Update Dummy Backend Data
If important data like the IP address of the MQTT broker or the UUID of the vehicle changes, there are three ways to tell the app. 
1. Either one updates the JSON, which can be found under `./Trittstufe/Model/DummyBackendData.swift`. 
2. You update the values manually in the app. 
3. Or you create a new QR code, which can be read by the app.



