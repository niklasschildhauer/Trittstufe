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
//    func did
//    func didLogoutAtBroker(in service: MQTTClientService)
}

protocol StepEngineControlServiceDelegate: AnyObject {
    func didReceive(message: String, in service: MQTTClientService)
}

protocol StepEngineControlService {
    var statusDelegate: StepEngineControlServiceDelegate? { get set }
    
    func extendStep()
}


class MQTTClientService {
    var auhtenticationDelegate: MQTTClientServiceAuthenticationDelegate?
    var statusDelegate: StepEngineControlServiceDelegate?
    
    private var mqttClient: CocoaMQTT?
    private let configurationService: ConfigurationService

    init(configurationService: ConfigurationService) {
        self.configurationService = configurationService
    }

    private func loginClientAtBroker(for account: String, password: String, completion: (Result<String, AuthenticationError>) -> Void) {
        guard let ipAdress = configurationService.ipAdress,
              let port = configurationService.port else {
                  //Todo what to do if this case occurs
                  fatalError()
              }
              
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        let client = CocoaMQTT(clientID: clientID, host: ipAdress, port: port)
        client.username = account
        client.password = password
        client.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        client.keepAlive = 60
        client.delegate = self
        let success = client.connect()
        
//        if success {
//            userIdentification = "Das ist eine ClientID"
//            userLoggedIn = true
//            mqttClient = client
//            completion(.success(userIdentification!))
//        } else {
//            userLoggedIn = false
//            completion(.failure(.serverError))
//        }
    }
}

extension MQTTClientService: StepEngineControlService {
    func extendStep() {
        guard let client = mqttClient else { return }
        let publishProperties = MqttPublishProperties()
        publishProperties.contentType = "JSON"

        client.publish("engine_control", withString: "Das ist ein Test", qos: .qos1)
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
