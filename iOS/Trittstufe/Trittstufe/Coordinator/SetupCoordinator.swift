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
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        
        let calculationViewController = createCalculateSetupStageViewController()
        navigationController.setViewControllers([calculationViewController], animated: false)
    }
    
    private func createCalculateSetupStageViewController() -> UIViewController {
        let viewController = CalculateSetupStageViewController()
        let presenter = CalculateSetupStagePresenter(authenticationService: authenticationService)
        
        viewController.presenter = presenter
        presenter.delegate = self
                
        return viewController
    }
        
    private func createConfigurationViewController() -> UIViewController {
        let viewController = ConfigurationViewController()
        let presenter = ConfigurationPresenter()
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        return viewController
    }
    
    private func createAuthenticationViewController() -> UIViewController {
        let viewController = AuthenticationViewController()
        let presenter = AuthenticationPresenter(authenticationService: authenticationService)
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        return viewController
    }
}

extension SetupCoordinator: SetupPresenterDelegate {
    func didCalculate(next stage: SetupStage, in presenter: CalculateSetupStagePresenter) {
        switch stage {
        case .configurationMissing:
            DispatchQueue.performUIOperation {
                self.rootViewController.present(self.createConfigurationViewController(), animated: true)
            }
        case .authenticationRequired:
            DispatchQueue.performUIOperation {
                self.navigationController.setViewControllers([self.createAuthenticationViewController()], animated: false)
            }
        case .setupCompleted(let clientConfiguration):
            DispatchQueue.performUIOperation {
                self.delegate?.didCompleteSetup(with: clientConfiguration, in: self)
            }
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
            self.navigationController.setViewControllers([self.createCalculateSetupStageViewController()], animated: false)
            self.rootViewController.dismiss(animated: true)
        }
    }
}

extension SetupCoordinator: AuthenticationPresenterDelegate {
    func didCompleteAuthentication(with clientConfiguration: ClientConfiguration, in presenter: AuthenticationPresenter) {
        DispatchQueue.performUIOperation {
            self.navigationController.setViewControllers([self.createCalculateSetupStageViewController()], animated: false)
        }
    }
    
    func didTapEditConfiguration(in presenter: AuthenticationPresenter) {
        let createConfigurationViewController = createConfigurationViewController()
        createConfigurationViewController.isModalInPresentation = true
        
        DispatchQueue.performUIOperation {
            self.rootViewController.present(createConfigurationViewController, animated: true)
        }
    }
}

