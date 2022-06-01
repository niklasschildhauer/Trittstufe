//
//  StepEngineControlService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 29.05.22.
//

import Foundation
import MQTTClient

protocol StepEngineControlServiceDelegate: AnyObject {
    func didReceive(stepStatus: [CarStepStatus], in service: StepEngineControlService)
    func didConnectToCar(in service: StepEngineControlService)
    func didDisconnectToCar(in service: StepEngineControlService)
}

protocol StepEngineControlService {
    var statusDelegate: StepEngineControlServiceDelegate? { get set }
    
    func connect(completion: @escaping (Result<String, AuthenticationError>) -> Void)
    func extendStep(on side: CarStepIdentification.Side)
    func shrinkStep(on side: CarStepIdentification.Side)
}

extension StepEngineControlService {
    
}


class MQTTClient: NSObject {
    private var transport = MQTTCFSocketTransport()
    fileprivate var session = MQTTSession()
    fileprivate var completion: (()->())?
    
    private let clientConfiguration: ClientConfiguration

    init(clientConfiguration: ClientConfiguration) {
        self.clientConfiguration = clientConfiguration
    }
    
    var statusDelegate: StepEngineControlServiceDelegate?
    
    func publishMessage(_ message: String, to topic: String) {
        session?.publishData(message.data(using: .utf8, allowLossyConversion: false), onTopic: topic, retain: false, qos: .exactlyOnce)
        
        print("Message: " + message, "--" + " Topic: " + topic)
        
    }
    
}

extension MQTTClient: StepEngineControlService {
    func connect(completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        self.session?.delegate = self
        self.transport.host = clientConfiguration.carIdentification.ipAdress
        self.transport.port = UInt32(clientConfiguration.carIdentification.portNumber)
        session?.transport = transport
        
        session?.connect() { error in
            //print("connection completed with status \(String(describing: error))")
            if error != nil {
                //self.updateUI(for: self.session?.status ?? .created)
                print("error during connection")
                completion(.failure(.internalError))
                
            } else {
                self.session?.subscribe(toTopic: "engine_control_status", at: .atLeastOnce)
                
                completion(.success("connected Successfully"))
                print("connected Successfully")
                //self.updateUI(for: self.session?.status ?? .error)
            }
        }
    }
    
    func extendStep(on side: CarStepIdentification.Side) {
        publishMessage(createPositionChangeJsonString(side: side, position: .open), to: "engine_control")

    }
    
    func shrinkStep(on side: CarStepIdentification.Side) {
        publishMessage(createPositionChangeJsonString(side: side, position: .close), to: "engine_control")

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

extension MQTTClient: MQTTSessionManagerDelegate, MQTTSessionDelegate {
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        if let msg = String(data: data, encoding: .utf8) {
            print("recieved message from topic \(topic!), msg \(msg)")
        }
    }
    
    func messageDelivered(_ session: MQTTSession, msgID msgId: UInt16) {
        print("delivered")
//        DispatchQueue.main.async {
//            self.completion?()
//        }
    }
    
}
