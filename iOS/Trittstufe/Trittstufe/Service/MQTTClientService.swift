//
//  MQTTClientService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import CocoaMQTT

protocol MQTTClientServiceAuthenticationDelegate: AnyObject {
//    func didRegisterForTopic(in service: MQTTClientService)
//    func didLogoutAtBroker(in service: MQTTClientService)
}

protocol StepEngineControlServiceDelegate: AnyObject {
    func didReceive(message: String, in service: MQTTClientService)
}

protocol StepEngineControlService {
    var statusDelegate: StepEngineControlServiceDelegate? { get set }
    
    func connect(completion: (Result<String, AuthenticationError>) -> Void)
    func extendStep()
    func shrinkStep()
}


class MQTTClientService {
    var auhtenticationDelegate: MQTTClientServiceAuthenticationDelegate?
    var statusDelegate: StepEngineControlServiceDelegate?
    
    private var mqttClient: CocoaMQTT?
    private let clientConfiguration: ClientConfiguration

    init(clientConfiguration: ClientConfiguration) {
        self.clientConfiguration = clientConfiguration
    }

    private func loginClientAtBroker(for account: String, password: String, completion: (Result<String, AuthenticationError>) -> Void) {
    
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        let client = CocoaMQTT(clientID: clientID,
                               host: clientConfiguration.carIdentification.ipAdress,
                               port: clientConfiguration.carIdentification.portNumber)
//        client.username = clientConfiguration.clientCredentials.accountName
//        client.password = clientConfiguration.clientCredentials.password
//        client.willMessage = CocoaMQTTMessage(topic: "", string: "dieout")
        client.keepAlive = 60
        client.delegate = self
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
        print(encryptedMessage)
        client.publish(topic, withString: encryptedMessage, qos: .qos0)
    }
}

extension MQTTClientService: StepEngineControlService {
    func connect(completion: (Result<String, AuthenticationError>) -> Void) {
        loginClientAtBroker(for: "", password: "", completion: completion)
    }
    
    func extendStep() {
        send(message: createPositionChangeJsonString(position: .open), to: "engine_control")
    }
    
    func shrinkStep() {
        send(message: createPositionChangeJsonString(position: .close), to: "engine_control")
    }
    
    enum Position: String {
        case open
        case close
    }
    
    private func createPositionChangeJsonString(position: Position) -> String {
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
//        if let completion = self.loginCompletion {
//            completion(.success("Das ist die User Id"))
//            loginCompletion = nil
//        } else {
//            auhtenticationDelegate?.didLoginUser(in: self)
//        }
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
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
