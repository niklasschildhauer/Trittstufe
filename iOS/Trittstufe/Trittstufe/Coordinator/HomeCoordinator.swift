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
    
    init(stepEngineControlService: StepEngineControlService) {
        self.stepEngineControlService = stepEngineControlService
        navigationController.setViewControllers([createHomeViewController()], animated: false)
    }
    
    private func createHomeViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter(stepEngineControlService: stepEngineControlService)

        homePresenter.delegate = self
        homeViewController.presenter = homePresenter
        
        return homeViewController
    }
}

extension HomeCoordinator: HomePresenterDelegate {
    func didTapLogout(in presenter: HomePresenter) {
        delegate?.didLogout(in: self)
    }
}
