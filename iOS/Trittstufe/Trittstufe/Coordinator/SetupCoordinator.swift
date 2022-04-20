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
    private var firstStage = true
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        setupApp()
        
        let calculationViewController = createCalculateSetupStageViewController()
        navigationController.setViewControllers([calculationViewController], animated: false)
    }
    
    private func setupApp() {
        GlobalAppearancee.styleNavigationBarFonts()
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
    
    private func showNext(viewController: UIViewController, animated: Bool) {
        DispatchQueue.performUIOperation {
            if self.firstStage {
                self.navigationController.setViewControllers([viewController], animated: true)
                self.firstStage = false
            } else {
                self.navigationController.popViewController(animated: false)
                self.navigationController.pushViewController(viewController, animated: animated)
            }
        }
    }
}

extension SetupCoordinator: SetupPresenterDelegate {
    func didCalculate(next stage: SetupStage, in presenter: CalculateSetupStagePresenter) {
        switch stage {
        case .configurationMissing:
            showNext(viewController: createConfigurationViewController(), animated: true)
        case .authenticationRequired:
            showNext(viewController: createAuthenticationViewController(), animated: true)
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
        showNext(viewController: createCalculateSetupStageViewController(), animated: false)
    }
}

extension SetupCoordinator: AuthenticationPresenterDelegate {
    func didCompleteAuthentication(with clientConfiguration: ClientConfiguration, in presenter: AuthenticationPresenter) {
        showNext(viewController: createCalculateSetupStageViewController(), animated: false)
    }
    
    func didTapEditConfiguration(in presenter: AuthenticationPresenter) {
        let configurationViewController = createConfigurationViewController()
        
        DispatchQueue.performUIOperation {
            self.rootViewController.present(configurationViewController, animated: true)
        }
    }
}

