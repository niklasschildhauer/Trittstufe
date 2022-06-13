//
//  MQTTClientService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import CocoaMQTT

class MQTTClientService {
    var statusDelegate: StepEngineControlServiceDelegate?
    
    enum Topic: String {
        case status = "status"
        case position = "set_position"
        
        func url(for step: CarStepIdentification) -> String {
            "arena2036/rolling_chassis/\(step.rawValue)/\(self.rawValue)"
        }
        
        static func step(for topicUrl: String) -> CarStepIdentification {
            let components = topicUrl.split(separator: "/")
            let indexOfCarId = components.firstIndex { $0 == "rolling_chassis" }
            
            guard let indexOfCarId = indexOfCarId,
                  let stepInt = Int(components[indexOfCarId + 1]),
                  let step = CarStepIdentification(rawValue: stepInt)
            else {
                print("Topic does not match pattern")
                return .unknown
            }
            
            return step
        }
    }
    
    private var mqttClient: CocoaMQTT?
    private var mqtt5Client: CocoaMQTT5?
    private let clientConfiguration: ClientConfiguration
    
    init(clientConfiguration: ClientConfiguration) {
        self.clientConfiguration = clientConfiguration
    }
    
    private func loginClientAtBroker(for account: String, password: String, completion: (Result<String, AuthenticationError>) -> Void) {
        
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        let client = CocoaMQTT(clientID: clientID,
                               host: clientConfiguration.carIdentification.ipAdress,
                               port: clientConfiguration.carIdentification.portNumber)
        client.keepAlive = 20
        client.delegate = self
        // client.autoReconnect = true
        client.logLevel = .debug
        let success = client.connect()
        
        if success {
            mqttClient = client
            completion(.success(clientID))
        } else {
            completion(.failure(.serverError))
        }
    }
    
    private func send(message: String, to topic: Topic, for step: CarStepIdentification) {
        guard let client = mqttClient else { return }
        
        let encryptedMessage = CryptoHelper.generateEncryptedJSONString(payload: message, publicKeyReviever: clientConfiguration.carIdentification.publicKey)
        
        client.publish(topic.url(for: step), withString: encryptedMessage, qos: .qos1)
    }
    
    private func checkStatus(for step: CarStepIdentification) {
        send(message: createPositionChangeJsonString(position: .unknown), to: .position, for: step)
    }
}

extension MQTTClientService: StepEngineControlService {
    func extend(step: CarStepIdentification) {
        send(message: createPositionChangeJsonString(position: .open), to: .position, for: step)
    }
    
    func shrink(step: CarStepIdentification) {
        send(message: createPositionChangeJsonString(position: .close), to: .position, for: step)
    }
    
    func connect(completion: (Result<String, AuthenticationError>) -> Void) {
        loginClientAtBroker(for: "", password: "", completion: completion)
    }
    
    private func createPositionChangeJsonString(position: CarStepStatus.Position) -> String {
        let json: [String: Any] = [
            "token": clientConfiguration.userToken,
            "position": position.rawValue
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        return String(data: jsonData, encoding: .utf8)!
    }
}


extension MQTTClientService: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect \(ack.description)")
        let topics = clientConfiguration.carIdentification.stepIdentifications.map { (Topic.status.url(for: $0), CocoaMQTTQoS.qos1) }
        mqtt.subscribe(topics)
        
        for step in clientConfiguration.carIdentification.stepIdentifications {
            checkStatus(for: step)
        }
                
        statusDelegate?.didConnectToCar(in: self)
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("diddisConnect")
        print(err?.localizedDescription ?? "")
        statusDelegate?.didDisconnectToCar(in: self)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
        
    }
    
    struct MQTTStatusMessage: Codable {
        let position: CarStepStatus.Position
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let topic = message.topic
        guard let message = message.string else {
            return
        }
        
        guard let statusMessage: MQTTStatusMessage = try? JSONDecoder().decode(MQTTStatusMessage.self, from: message.data(using: .utf8)!) else {
            print("JSON format invalid for status message")
            return
        }
        
        let stepStatus = CarStepStatus(step: Topic.step(for: topic), position: statusMessage.position)
        
        statusDelegate?.didReceive(stepStatus: stepStatus, in: self)
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
    
}
