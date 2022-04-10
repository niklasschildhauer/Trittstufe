//
//  AppCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var rootViewController: UIViewController! = UIViewController() {
        didSet {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
    
    private let window: UIWindow
    
    private let mqttClientService = MQTTClientService()

    private lazy var homeCoordinator: HomeCoordinator = {
        let coordinator = HomeCoordinator(mqttClientService: mqttClientService)
        return coordinator
    }()
    
    private lazy var setupCoordinator: SetupCoordinator = {
        let coordinator = SetupCoordinator()
        coordinator.delegate = self
        
        return coordinator
    }()

    init(window: UIWindow) {
        self.window = window
        defer {
            rootViewController = setupCoordinator.rootViewController
        }
    }
}

extension AppCoordinator: SetupCoordinatorDelegate {
    func didCompleteSetup(in coordinator: SetupCoordinator) {
        DispatchQueue.scheduleOnMainThread {
            self.rootViewController = self.homeCoordinator.rootViewController
        }
    }
}
