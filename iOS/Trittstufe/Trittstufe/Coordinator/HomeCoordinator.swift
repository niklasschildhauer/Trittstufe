//
//  HomeCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var rootViewController: UIViewController! {
        navigationController
    }

    private let navigationController = UINavigationController()
    private let mqttClientService: MQTTClientService
    
    init(mqttClientService: MQTTClientService) {
        self.mqttClientService = mqttClientService
        navigationController.setViewControllers([createHomeViewController()], animated: false)
    }
    
    private func createHomeViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter(mqttClientService: mqttClientService)

        homeViewController.presenter = homePresenter
        
        return homeViewController
    }
}
