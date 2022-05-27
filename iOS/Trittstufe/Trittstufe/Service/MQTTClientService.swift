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
    func didReceive(stepStatus: [CarStepStatus], in service: StepEngineControlService)
    func didConnectToCar(in service: StepEngineControlService)
    func didDisconnectToCar(in service: StepEngineControlService)
}

protocol StepEngineControlService {
    var statusDelegate: StepEngineControlServiceDelegate? { get set }
    
    func connect(completion: (Result<String, AuthenticationError>) -> Void)
    func extendStep(on side: CarStepIdentification.Side)
    func shrinkStep(on side: CarStepIdentification.Side)
}


class MQTTClientService {
    var auhtenticationDelegate: MQTTClientServiceAuthenticationDelegate?
    var statusDelegate: StepEngineControlServiceDelegate?
    
    private var mqttClient: CocoaMQTT?
    private var mqtt5Client: CocoaMQTT5?
    private let clientConfiguration: ClientConfiguration
    
    struct StepStatus: Codable {
        var position: CarStepStatus.Position
        var side: CarStepIdentification.Side
    }
    
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
        //client.autoReconnect = true
        client.logLevel = .debug
        let success = client.connect()

        if success {
            mqttClient = client
            completion(.success("Das ist eine ClientID"))
        } else {
            completion(.failure(.serverError))
        }
        
//        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
//        let mqtt5 = CocoaMQTT5(clientID: clientID, host: "localhost", port: 1883)
//
//        let connectProperties = MqttConnectProperties()
//        connectProperties.topicAliasMaximum = 0
//        connectProperties.sessionExpiryInterval = 0
//        //connectProperties.receiveMaximum = 100
//        //connectProperties.maximumPacketSize = 500
//        mqtt5.connectProperties = connectProperties
//
//        mqtt5.username = "test"
//        mqtt5.password = "public"
////        mqtt5.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
//        mqtt5.keepAlive = 60
//        mqtt5.delegate = self
//        let success = mqtt5.connect()
//
//        if success {
//           mqtt5Client = mqtt5
//           completion(.success("Das ist eine ClientID"))
//       } else {
//           completion(.failure(.serverError))
//       }
    }
    
    private func send(message: String, to topic: String) {
        guard let client = mqttClient else { return }
                
        let encryptedMessage = CryptoHelper.generateEncryptedJSONString(payload: message, publicKeyReviever: "XWOVfM+MFrs26wdQntzXUjatvN/CJvDQ47sd/LZ1YwQ=")
        
        client.publish(topic, withString: encryptedMessage, qos: .qos1)
    }
}

extension MQTTClientService: StepEngineControlService {
    func connect(completion: (Result<String, AuthenticationError>) -> Void) {
        loginClientAtBroker(for: "", password: "", completion: completion)
    }
    
    func extendStep(on side: CarStepIdentification.Side) {
        send(message: createPositionChangeJsonString(side: side, position: .open), to: "engine_control")
    }
    
    func shrinkStep(on side: CarStepIdentification.Side) {
        send(message: createPositionChangeJsonString(side: side, position: .open), to: "engine_control")
    }

    private func createPositionChangeJsonString(side: CarStepIdentification.Side, position: CarStepStatus.Position) -> String {
        let json: [String: Any] = [
            "token": clientConfiguration.userToken,
            "side": side.rawValue,
            "position": position.rawValue
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        return String(data: jsonData, encoding: .utf8)!
    }
}

//extension MQTTClientService: CocoaMQTT5Delegate {
//    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck) {
//        print("didConnect")
//        statusDelegate?.didConnectToCar(in: self)
//        mqtt5.subscribe("engine_control_status", qos: .qos1)
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
//        print("didPublishMessage")
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck) {
//
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec) {
//
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish) {
//        guard let message = message.string else { return }
//        statusDelegate?.didReceive(message: message, in: self)
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck) {
//        print("didSubscribeTopics")
//
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], UnsubAckData: MqttDecodeUnsubAck) {
//        print("didUnsubscribeTopics")
//
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
//        print("didReceiveDisconnectReasonCode: \(reasonCode)")
//    }
//
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
//
//    }
//
//    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
//        print("didPong")
//    }
//
//    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
//        print("didRecievePong")
//
//    }
//
//    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
//        print("didDisconnect")
//        print(err?.localizedDescription)
//        statusDelegate?.didDisconnectToCar(in: self)
//    }
//}

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
        
        let stepStatus: [StepStatus]? = try? JSONDecoder().decode([StepStatus].self, from: message.data(using: .utf8)!)
        
        guard let stepStatus = stepStatus else { return }

        
        let carStepStatus: [CarStepStatus] = stepStatus.compactMap { mqttStatus in
            if let step = clientConfiguration.carIdentification.steps.first(where: { step in
                mqttStatus.side == step.side
            }){
                return CarStepStatus(stepIdentification: step, position: mqttStatus.position)
            }
            return nil
        }
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
