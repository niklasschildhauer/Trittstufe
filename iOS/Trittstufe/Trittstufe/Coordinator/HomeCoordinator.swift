//
//  HomeCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var rootViewController: UIViewController! {
        navigationController
    }

    private let navigationController = UINavigationController()
    
    init() {
        navigationController.viewControllers = [createHomeViewController()]
    }
    
    private func createHomeViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter()

        homeViewController.presenter = homePresenter
        
        return homeViewController
    }
}
