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
    
    private let configurationService = ConfigurationService()
    private var userService: UserService?

    private var homeCoordinator: HomeCoordinator {
        let mqttClient = MQTTClientService(configurationService: configurationService)
    
        let coordinator = HomeCoordinator(stepEngineControlService: mqttClient)
        coordinator.delegate = self
        
        return coordinator
    }
    
    private var setupCoordinator: SetupCoordinator {
        let keychainService = KeychainService()
        let userService = LocalUserService(keychainService: keychainService)
        let coordinator = SetupCoordinator(userService: userService, configurationService: configurationService)
        coordinator.delegate = self
        
        self.userService = userService
        
        return coordinator
    }

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

extension AppCoordinator: HomeCoordinatorDelegate {
    func didLogout(in coordinator: HomeCoordinator) {
        userService?.logout()
        DispatchQueue.scheduleOnMainThread {
            self.rootViewController = self.setupCoordinator.rootViewController
        }
    }
}
