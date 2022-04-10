//
//  SetupCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit

protocol SetupCoordinatorDelegate: AnyObject {
    func didCompleteSetup(in coordinator: SetupCoordinator)
}

class SetupCoordinator: Coordinator {
    var rootViewController: UIViewController! {
        navigationController
    }
    
    weak var delegate: SetupCoordinatorDelegate?

    private let navigationController = UINavigationController()
    
    init() {
        pushCalculateSetupStageViewController()
    }
    
    private func pushCalculateSetupStageViewController() {
        let viewController = CalculateSetupStageViewController()
        let presenter = CalculateSetupStagePresenter()
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        presenter.state = testBool
        
        DispatchQueue.scheduleOnMainThread {
            self.navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
    private var testBool = false
    
    private func pushConfigurationViewController() {
        let viewController = ConfigurationViewController()
        let presenter = ConfigurationPresenter()
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        DispatchQueue.scheduleOnMainThread {
            self.navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
    private func pushAuthenticationViewController() {
        let viewController = AuthenticationViewController()
        let presenter = AuthenticationPresenter()
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        DispatchQueue.scheduleOnMainThread {
            self.navigationController.setViewControllers([viewController], animated: false)
        }
    }
}

extension SetupCoordinator: SetupPresenterDelegate {
    func didCalculate(next stage: SetupStage, in presenter: CalculateSetupStagePresenter) {

        switch stage {
        case .configurationMissing:
            pushConfigurationViewController()
        case .authenticationRequired:
            pushAuthenticationViewController()
        case .setupCompleted:
            delegate?.didCompleteSetup(in: self)
        }
    }
}

extension SetupCoordinator: ConfigurationPresenterDelegate {
    func didCompletecConfiguration(in presenter: ConfigurationPresenter) {
        testBool = true
        pushCalculateSetupStageViewController()
    }
}

extension SetupCoordinator: AuthenticationPresenterDelegate {
    func didCompletecAuthentication(in presenter: AuthenticationPresenter) {
        pushCalculateSetupStageViewController()
    }    
}
