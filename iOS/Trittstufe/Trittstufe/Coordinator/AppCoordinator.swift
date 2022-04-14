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
    
    private var AuthenticationService: AuthenticationService?
    
    init(window: UIWindow) {
        self.window = window
        defer {
            rootViewController = createSetupCoordinator().rootViewController
        }
    }

    private func createHomeCoordinator(with clientConfiguration: ClientConfiguration) -> HomeCoordinator {
        let mqttClient = MQTTClientService(clientConfiguration: clientConfiguration)
    
        let coordinator = HomeCoordinator(stepEngineControlService: mqttClient)
        coordinator.delegate = self
        
        return coordinator
    }
    
    private func createSetupCoordinator() -> SetupCoordinator {
        let keychainService = KeychainService()
        let AuthenticationService = LocalAuthenticationService(keychainService: keychainService)
        let coordinator = SetupCoordinator(AuthenticationService: AuthenticationService)
        coordinator.delegate = self
        
        self.AuthenticationService = AuthenticationService
        
        return coordinator
    }
}

extension AppCoordinator: SetupCoordinatorDelegate {
    func didCompleteSetup(with clientConfiguration: ClientConfiguration, in coordinator: SetupCoordinator) {
        DispatchQueue.scheduleOnMainThread {
            self.rootViewController = self.createHomeCoordinator(with: clientConfiguration).rootViewController
        }
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func didLogout(in coordinator: HomeCoordinator) {
        AuthenticationService?.logout()
        DispatchQueue.scheduleOnMainThread {
            self.rootViewController = self.createSetupCoordinator().rootViewController
        }
    }
}
