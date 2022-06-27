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
    private let setupStageService: SetupStageService
    private var firstStage = true
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        self.setupStageService = SetupStageService(authenticationService: authenticationService)
        
        setupApp()
        
        let calculationViewController = createCalculateSetupStageViewController()
        navigationController.setViewControllers([calculationViewController], animated: false)
    }
    
    private func setupApp() {
        GlobalAppearance.styleNavigationBarFonts()
    }
    
    private func createCalculateSetupStageViewController() -> UIViewController {
        let viewController = SetupLoadingViewController ()
        let presenter = SetupLoadingPresenter()
        
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
    
    private func showNextStage() {
        let stage = setupStageService.calculateNextStage()
        switch stage {
        case .configurationMissing:
            self.showNext(viewController: self.createConfigurationViewController(), animated: true)
        case .authenticationRequired:
            self.showNext(viewController: self.createAuthenticationViewController(), animated: true)
        case .setupCompleted(let clientConfiguration):
            DispatchQueue.performUIOperation {
                self.delegate?.didCompleteSetup(with: clientConfiguration, in: self)
            }
            
        }
    }
}

extension SetupCoordinator: SetupLoadingPresenterDelegate {
    func setupDidAppear(in presenter: SetupLoadingPresenter) {
        showNextStage()
    }
}

extension SetupCoordinator: ConfigurationPresenterDelegate {
    func didCompletecConfiguration(in presenter: ConfigurationPresenter) {
        if rootViewController.presentedViewController == nil {
            showNextStage()
        } else {
            rootViewController.dismiss(animated: true)
        }
    }
}

extension SetupCoordinator: AuthenticationPresenterDelegate {
    func didCompleteAuthentication(with clientConfiguration: ClientConfiguration, in presenter: AuthenticationPresenter) {
        showNextStage()
        
    }
    
    func didTapEditConfiguration(in presenter: AuthenticationPresenter) {
        let configurationViewController = createConfigurationViewController()
        
        let navigationController = UINavigationController()
        navigationController.setViewControllers([configurationViewController], animated: false)
        
        DispatchQueue.performUIOperation {
            self.rootViewController.present(navigationController, animated: true)
        }
    }
}

