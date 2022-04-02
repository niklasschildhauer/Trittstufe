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
            window.makeKeyAndVisible()
        }
    }
    
    private let window: UIWindow
    
    private lazy var homeCoordinator: HomeCoordinator = {
        let coordinator = HomeCoordinator()
        return coordinator
    }()

    init(window: UIWindow) {
        self.window = window
        defer {
            rootViewController = homeCoordinator.rootViewController
        }
    }
}
