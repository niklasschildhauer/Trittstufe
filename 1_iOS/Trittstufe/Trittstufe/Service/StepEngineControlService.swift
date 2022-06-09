//
//  StepEngineControlService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 29.05.22.
//

import Foundation
import MQTTClient

protocol StepEngineControlServiceDelegate: AnyObject {
    func didReceive(stepStatus: CarStepStatus, in service: StepEngineControlService)
    func didConnectToCar(in service: StepEngineControlService)
    func didDisconnectToCar(in service: StepEngineControlService)
}

protocol StepEngineControlService {
    var statusDelegate: StepEngineControlServiceDelegate? { get set }
    
    func connect(completion: @escaping (Result<String, AuthenticationError>) -> Void)
    func extend(step: CarStepIdentification)
    func shrink(step: CarStepIdentification)
}

