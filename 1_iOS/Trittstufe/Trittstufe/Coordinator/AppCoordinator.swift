//
//  AppCoordinator.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//  Modified by Ansgar Gerlicher on 11.07.22.

import Foundation
import UIKit

/// Main coordinator. Called right after startup and is responsible for creating the setup and home coordinator. First the setup coordinator is displayed and after the setup is finished the home coordinator is presented.
class AppCoordinator: Coordinator {
    var rootViewController: UIViewController! = UIViewController() {
        didSet {
            window.rootViewController = rootViewController

            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.5

            /// Creates a transition animation.
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { completed in
                self.window.makeKeyAndVisible()
            })
        }
    }
    
    private let window: UIWindow
    var carIsBooked : Bool = false
    private var authenticationService: AuthenticationService?
    private let locationService = LocationService()
    private var bookingCoordinator : BookingCoordinator?
    
    init(window: UIWindow) {
        self.window = window
       
        rootViewController = createSetupCoordinator().rootViewController
        window.rootViewController = rootViewController
    }
    
    private func createBookingCoordinator(with clientConfiguration: ClientConfiguration) -> BookingCoordinator {
        
        if bookingCoordinator == nil {
            let coordinator = BookingCoordinator(clientConfiguration: clientConfiguration)
            coordinator.delegate = self
            bookingCoordinator = coordinator
        }
        
        return bookingCoordinator!
    }
    

    private func createHomeCoordinator(with clientConfiguration: ClientConfiguration) -> HomeCoordinator {    
        let coordinator = HomeCoordinator(clientConfiguration: clientConfiguration, locationService: locationService)
        coordinator.delegate = self
        
        return coordinator
    }
    
    private func createSetupCoordinator() -> SetupCoordinator {
        let keychainService = KeychainService()
        let networkService = LocalNetworkService()
        let authenticationService = LocalAuthenticationService(keychainService: keychainService, networkService: networkService)
        let coordinator = SetupCoordinator(authenticationService: authenticationService)
        coordinator.delegate = self
        
        self.authenticationService = authenticationService
        
        return coordinator
    }
}

extension AppCoordinator: SetupCoordinatorDelegate {
    func didCompleteSetup(with clientConfiguration: ClientConfiguration, in coordinator: SetupCoordinator) {
        
        // if car is booked show homecoordinator else booking screen
        DispatchQueue.scheduleOnMainThread {
            if self.carIsBooked {
            self.rootViewController = self.createHomeCoordinator(with: clientConfiguration).rootViewController
            } else {
                self.rootViewController = self.createBookingCoordinator(with: clientConfiguration).rootViewController
            }
            
        }
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func didLogout(in coordinator: HomeCoordinator) {
        authenticationService?.logout()
        DispatchQueue.scheduleOnMainThread {
            // Logout is leading to unbooking a car
            self.carIsBooked = false
            if let coordinator = self.bookingCoordinator {
                coordinator.cancelBooking()
            }
            self.rootViewController = self.createSetupCoordinator().rootViewController
        }
    }
}

extension AppCoordinator: BookingCoordinatorDelegate {

    func didBook(with clientConfiguration: ClientConfiguration, in coordinator: BookingCoordinator) {
        
        DispatchQueue.scheduleOnMainThread {
            self.carIsBooked = true
            self.rootViewController = self.createHomeCoordinator(with: clientConfiguration).rootViewController
        }
    }
}
