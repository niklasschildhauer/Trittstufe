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
        //client.autoReconnect = true
        client.logLevel = .debug
        let success = client.connect()

        if success {
            mqttClient = client
            completion(.success("Das ist eine ClientID"))
        } else {
            completion(.failure(.serverError))
        }
    }
    
    private func send(message: String, to topic: String) {
        guard let client = mqttClient else { return }
                
        let encryptedMessage = CryptoHelper.generateEncryptedJSONString(payload: message, publicKeyReviever: "XWOVfM+MFrs26wdQntzXUjatvN/CJvDQ47sd/LZ1YwQ=")
        
        client.publish(topic, withString: encryptedMessage, qos: .qos1)
    }
}

extension MQTTClientService: StepEngineControlService {
    func extend(step: CarStepIdentification) {
        send(message: createPositionChangeJsonString(step: step, position: .open), to: "engine_control")
    }
    
    func shrink(step: CarStepIdentification) {
        send(message: createPositionChangeJsonString(step: step, position: .close), to: "engine_control")
    }
    
    func connect(completion: (Result<String, AuthenticationError>) -> Void) {
        loginClientAtBroker(for: "", password: "", completion: completion)
    }
    
    private func createPositionChangeJsonString(step: CarStepIdentification, position: CarStepStatus.Position) -> String {
        let json: [String: Any] = [
            "token": clientConfiguration.userToken,
            "step": step.rawValue,
            "position": position.rawValue
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        return String(data: jsonData, encoding: .utf8)!
    }
}


extension MQTTClientService: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect")
        statusDelegate?.didConnectToCar(in: self)
        
        mqtt.subscribe("engine_control_status", qos: .qos1)

//        if let completion = self.loginCompletion {
//            completion(.success("Das ist die User Id"))
//            loginCompletion = nil
//        } else {
//            auhtenticationDelegate?.didLoginUser(in: self)
//        }
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("diddisConnect")
        print(err?.localizedDescription)
        statusDelegate?.didDisconnectToCar(in: self)

//        if let completion = self.loginCompletion {
//            completion(.failure(AuthenticationError.serverError))
//            loginCompletion = nil
//        } else {
//            auhtenticationDelegate?.didLogoutUser(in: self)
//        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        guard let message = message.string else { return }
        
        let carStepStatus: [CarStepStatus]? = try? JSONDecoder().decode([CarStepStatus].self, from: message.data(using: .utf8)!)
        
        guard let carStepStatus = carStepStatus else { return }

        statusDelegate?.didReceive(stepStatus: carStepStatus, in: self)
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
