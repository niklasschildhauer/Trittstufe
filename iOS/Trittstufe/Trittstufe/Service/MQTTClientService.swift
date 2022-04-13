//
//  MQTTClientService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import CocoaMQTT

protocol MQTTClientServiceAuthenticationDelegate: AnyObject {
    func didLoginUser(in service: MQTTClientService)
    func didLogoutUser(in service: MQTTClientService)
}

protocol MQTTClientServiceMessageDelegate: AnyObject {
    func didReceive(message: String, in service: MQTTClientService)
}

enum AuthenticationError: Error {
    case invalidLoginCredentials
    case noNetwork
    case serverError
}

protocol MessageService {
    func send(message: String)
}

protocol UserService {
    var auhtenticationDelegate: MQTTClientServiceAuthenticationDelegate? { get set }
    
    var userLoggedIn: Bool { get }
    var accountName: String? { get }
    var rememberMe: Bool { get }
    
    func loginWithRememberMe(completion: (Result<String, AuthenticationError>) -> Void)
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<String, AuthenticationError>) -> Void)
}

class MQTTClientService {
    var userLoggedIn = false {
        didSet {
            if !userLoggedIn {
                userIdentification = nil
                try? keychainService.deletePassword(account: accountName ?? "")
                accountName = nil
                mqttClient = nil
                rememberMe = false
                userIdentification = nil
            }
        }
    }
    var accountName: String? {
        get {
            UserDefaultConfig.accountName
        }
        set {
            UserDefaultConfig.accountName = newValue
        }
    }
    var rememberMe: Bool {
        get {
            UserDefaultConfig.rememberMe
        }
        set {
            UserDefaultConfig.rememberMe = newValue
        }
    }
    
    weak var auhtenticationDelegate: MQTTClientServiceAuthenticationDelegate?
    weak var messageDelegate: MQTTClientServiceMessageDelegate?
    
    private var loginCompletion: ((Result<String, AuthenticationError>) -> Void)?

    private var mqttClient: CocoaMQTT?
    private let configurationService: ConfigurationService
    private let keychainService: KeychainService

    private var userIdentification: String?
    
    init(keychainService: KeychainService, configurationService: ConfigurationService) {
        self.keychainService = keychainService
        self.configurationService = configurationService
    }
}

/// Mark: User Service
extension MQTTClientService: UserService {
    
    func loginWithRememberMe(completion: (Result<String, AuthenticationError>) -> Void) {
        guard let accountName = accountName, let password = try? keychainService.readPassword(account: accountName) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }
        loginClientAtBroker(for: accountName, password: password, completion: completion)
    }
        
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<String, AuthenticationError>) -> Void) {
        self.rememberMe = rememberMe
        loginClientAtBroker(for: accountName, password: password, completion: completion)
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
        
        if success {
            userIdentification = "Das ist eine ClientID"
            userLoggedIn = true
            mqttClient = client
            completion(.success(userIdentification!))
        } else {
            userLoggedIn = false
            completion(.failure(.serverError))
        }
    }
    
    func logout() {
        userLoggedIn = false
        auhtenticationDelegate?.didLogoutUser(in: self)
    }
}

/// Mark: Message Service
extension MQTTClientService: MessageService, CocoaMQTTDelegate {
    
    func send(message: String) {
        guard let client = mqttClient else { return }
        let publishProperties = MqttPublishProperties()
        publishProperties.contentType = "JSON"

        client.publish("engine_control", withString: "Das ist ein Test", qos: .qos1)
    }
    
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
        messageDelegate?.didReceive(message: message, in: self)

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
