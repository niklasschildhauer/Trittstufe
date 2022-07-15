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

class BookingCoordinator : Coordinator, BookingCoordinatorPresenter, StepEngineControlServiceDelegate {
    
    var isBooked : Bool = false
    
    func didReceive(stepStatus: CarStepStatus, in service: StepEngineControlService) {
        
    }
    
    func didConnectToCar(in service: StepEngineControlService) {
        if isBooked {
            self.stepEngineControlService.book()
            delegate?.didBook(with: self.clientConfiguration, in: self)
        } else {
            self.stepEngineControlService.cancelBooking()
        }
        
    }
    
    func didDisconnectToCar(in service: StepEngineControlService) {
    
    }
    
    
    
    var rootViewController: UIViewController!
    var delegate: BookingCoordinatorDelegate?
    private let clientConfiguration: ClientConfiguration
    private var stepEngineControlService: MQTTClientService
    
    init(clientConfiguration: ClientConfiguration) {
        self.clientConfiguration = clientConfiguration
        self.stepEngineControlService = MQTTClientService(clientConfiguration: clientConfiguration)
        self.stepEngineControlService.statusDelegate = self
        self.rootViewController = createBookingViewController()
    }
    
    func bookCar() {
       // Calling connect via MQTTClient -> Booking message is send via delegate in didConnectToCar()
        isBooked = true
        self.stepEngineControlService.connect() { _ in  }
        
    }
    
    func cancelBooking() {
        isBooked = false
        self.stepEngineControlService.connect() { _ in  }
    }
  
    
    
    private func createBookingViewController() -> UIViewController {
        let bookingViewController = BookingViewController()
        bookingViewController.presenter = self
        
        return bookingViewController
    }
}
