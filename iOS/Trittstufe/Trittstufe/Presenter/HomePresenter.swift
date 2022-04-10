//
//  HomePresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

protocol HomeView: AnyObject {
    var presenter: HomePresenter! { get set }
}

protocol HomePresenterDelegate: AnyObject {
    
}

class HomePresenter: Presenter {
    weak var view: HomeView?
    weak var delegate: HomePresenterDelegate?
    
    private let mqttClientService: MQTTClientService
    
    init(mqttClientService: MQTTClientService) {
        self.mqttClientService = mqttClientService
    }
    
    func viewDidLoad() {
        
    }
    
    func sendTestMessage() {
        mqttClientService.sendTestMessage()
    }
}
