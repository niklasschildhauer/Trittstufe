//
//  HomeCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func didLogout(in coordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator {
    var rootViewController: UIViewController! {
        navigationController
    }
    
    var delegate: HomeCoordinatorDelegate?
    private let navigationController = UINavigationController()
    private let stepEngineControlService: StepEngineControlService
    private let locationService: LocationService
    
    init(clientConfiguration: ClientConfiguration, locationService: LocationService) {
        locationService.clientConfiguration = clientConfiguration
        self.locationService = locationService
        self.stepEngineControlService = MQTTClientService(clientConfiguration: clientConfiguration)

        navigationController.setViewControllers([createHomeViewController()], animated: false)
    }
    
    private func createHomeViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter(stepEngineControlService: stepEngineControlService, locationService: locationService)

        homePresenter.delegate = self
        homeViewController.presenter = homePresenter
        
        return homeViewController
    }
    
    private func createRequestLocationPermissionViewController() -> UIViewController {
        let viewController = RequestLocationPermissionViewController()
        let presenter = RequestLocationPermissionPresenter(locationService: locationService)
        
        viewController.presenter = presenter
        presenter.delegate = self
        
        return viewController
    }
}

extension HomeCoordinator: HomePresenterDelegate {
    func didChangePermissionStatus(in presenter: HomePresenter) {
        DispatchQueue.performUIOperation {
            self.rootViewController.present(self.createRequestLocationPermissionViewController(), animated: true, completion: nil)
        }
    }
    
    func didTapLogout(in presenter: HomePresenter) {
        delegate?.didLogout(in: self)
    }
}

extension HomeCoordinator: RequestLocationPermissionPresenterDelegate {
    func didGrantedPermission(in presenter: RequestLocationPermissionPresenter) {
        DispatchQueue.performUIOperation {
            self.navigationController.setViewControllers([self.createHomeViewController()], animated: false)
            self.rootViewController.dismiss(animated: true)
        }
    }
}
