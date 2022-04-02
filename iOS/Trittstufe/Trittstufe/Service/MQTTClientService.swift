//
//  MQTTClientService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import CocoaMQTT

class MQTTClientService {
    private static let hostID = "192.168.0.65"
    private static let port: UInt16 = 1883
    
    private var mqttClient: CocoaMQTT!
    
    init() {
        setupMQTTClient()
    }
    
    private func setupMQTTClient() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: MQTTClientService.hostID, port: MQTTClientService.port)
//        mqttClient.username = "test"
//        mqttClient.password = "public"
        mqttClient.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqttClient.keepAlive = 60
        mqttClient.delegate = self
        mqttClient.connect()
    }
    
    func sendTestMessage() {
        let publishProperties = MqttPublishProperties()
        publishProperties.contentType = "JSON"

        mqttClient.publish("engine_control", withString: "Das ist ein Test", qos: .qos1)
    }
}

extension MQTTClientService: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("didSubscribeTopics")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("didUnsubscribeTopics")

    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")

    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")

    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect")

    }
}
