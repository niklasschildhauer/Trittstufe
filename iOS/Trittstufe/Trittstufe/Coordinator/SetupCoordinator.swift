//
//  SetupCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit

protocol SetupCoordinatorDelegate: AnyObject {
    func didCompleteSetup(with clientConfiguration: ClientConfiguration, in coordinator: SetupCoordinator)
}

class SetupCoordinator: Coordinator {
    var rootViewController: UIViewController! {
        navigationController
    }
    
    var delegate: SetupCoordinatorDelegate?

    private let navigationController = UINavigationController()
    private let AuthenticationService: AuthenticationService
    
    init(AuthenticationService: AuthenticationService) {
        self.AuthenticationService = AuthenticationService
        
        pushCalculateSetupStageViewController()
    }

    private func pushCalculateSetupStageViewController() {
        let viewController = CalculateSetupStageViewController()
        let presenter = CalculateSetupStagePresenter(AuthenticationService: AuthenticationService)
        
        viewController.presenter = presenter
        presenter.delegate = self
                
        DispatchQueue.scheduleOnMainThread {
            self.navigationController.setViewControllers([viewController], animated: false)
        }
    }
        
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
        let presenter = AuthenticationPresenter(AuthenticationService: AuthenticationService)
        
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
            DispatchQueue.performUIOperation {
                self.pushConfigurationViewController()
            }
        case .authenticationRequired:
            DispatchQueue.performUIOperation {
                self.pushAuthenticationViewController()
            }
        case .setupCompleted(let clientConfiguration):
            delegate?.didCompleteSetup(with: clientConfiguration, in: self)
        }
    }
}

extension SetupCoordinator: ConfigurationPresenterDelegate {
    func didTapShowQRCodeScanner(in presenter: ConfigurationPresenter) {
        let viewController  = QRCodeScannerViewController()
        viewController.delegate = presenter
        
        DispatchQueue.performUIOperation {
            self.rootViewController.present(viewController, animated: true, completion: nil)
        }
    }
    
    func didCompletecConfiguration(in presenter: ConfigurationPresenter) {
        DispatchQueue.performUIOperation {
            self.pushCalculateSetupStageViewController()
        }
    }
}

extension SetupCoordinator: AuthenticationPresenterDelegate {
    func didCompleteAuthentication(with clientConfiguration: ClientConfiguration, in presenter: AuthenticationPresenter) {
        DispatchQueue.performUIOperation {
            self.pushCalculateSetupStageViewController()
        }
    }
    
    func didTapEditConfiguration(in presenter: AuthenticationPresenter) {
        DispatchQueue.performUIOperation {
            self.pushConfigurationViewController()
        }
    }
}

