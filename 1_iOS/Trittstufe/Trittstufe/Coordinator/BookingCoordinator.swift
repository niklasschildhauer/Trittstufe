//
//  BookingCoordinator.swift
//  Trittstufe
//
//  Created by Ansgar Gerlicher on 11.07.22.
//

import Foundation
import UIKit

protocol BookingCoordinatorPresenter {
    func bookCar()
}

protocol BookingCoordinatorDelegate: AnyObject {
    func didBook(with clientConfiguration: ClientConfiguration, in coordinator: BookingCoordinator)
}

class BookingCoordinator : Coordinator, BookingCoordinatorPresenter {
    var rootViewController: UIViewController!
    var delegate: BookingCoordinatorDelegate?
    private let clientConfiguration: ClientConfiguration
    private let stepEngineControlService: StepEngineControlService
    
    init(clientConfiguration: ClientConfiguration) {
        self.clientConfiguration = clientConfiguration
        self.stepEngineControlService = MQTTClientService(clientConfiguration: clientConfiguration)
        self.rootViewController = createBookingViewController()
    }
    
    func bookCar() {
        //TODO send MQTT Message to Broker to get car coming
        delegate?.didBook(with: self.clientConfiguration, in: self)
    }
    
    private func createBookingViewController() -> UIViewController {
        let bookingViewController = BookingViewController()
        bookingViewController.presenter = self
        
        return bookingViewController
    }
}
