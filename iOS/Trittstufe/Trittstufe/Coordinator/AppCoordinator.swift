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

            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.5

            // Creates a transition animation.
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { completed in
                self.window.makeKeyAndVisible()
            })
        }
    }
    
    private let window: UIWindow
    
    private let mqttClientService = MQTTClientService()
    private let configurationService = ConfigurationService()
    private let userService: UserService = {
        let keychainService = KeychainService()
        return UserService(keychainService: keychainService)
    }()

    private lazy var homeCoordinator: HomeCoordinator = {
        let coordinator = HomeCoordinator(mqttClientService: mqttClientService)
        return coordinator
    }()
    
    private lazy var setupCoordinator: SetupCoordinator = {
        let coordinator = SetupCoordinator(userService: userService, configurationService: configurationService)
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
