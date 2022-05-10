//
//  HomePresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit
import CoreLocation

protocol HomeView: AnyObject {
    var presenter: HomePresenter! { get set }
    
    func display(carDistance: String)
    func display(openButton: Bool)
    func display(stepPosition: StepPosition)
}

protocol HomePresenterDelegate: AnyObject {
    func didTapLogout(in presenter: HomePresenter)
    func didChangePermissionStatus(in presenter: HomePresenter)
}

class HomePresenter: Presenter {
    weak var view: HomeView?
    var delegate: HomePresenterDelegate?
    
    private var stepEngineControlService: StepEngineControlService
    private let locationService: LocationService
    
    init(stepEngineControlService: StepEngineControlService, locationService: LocationService) {
        self.stepEngineControlService = stepEngineControlService
        self.locationService = locationService
        
    }

    func viewDidLoad() {
        locationService.statusDelegate = self
        locationService.delegate = self
        
        if locationService.permissionStatus() == .granted {
            startLocationService()
            startEngineControlService()
        } else {
            delegate?.didChangePermissionStatus(in: self)
        }
    }
    
    private func startLocationService() {
        locationService.startMonitoring()
        
        view?.display(openButton: false)
    }
    
    private func startEngineControlService() {
        stepEngineControlService.connect() { _ in }
        stepEngineControlService.statusDelegate = self
    }
    
    private func stopLocationService() {
        locationService.stopMonitoring()
    }
    
    func extendStep() {
        stepEngineControlService.extendStep()
    }
    
    func shrinkStep() {
        stepEngineControlService.shrinkStep()
    }
    
    func logout() {
        delegate?.didTapLogout(in: self)
    }
}

extension HomePresenter: LocationServiceStatusDelegate {
    func didChangeStatus(in service: LocationService) {
        switch service.permissionStatus() {
        case .granted:
            startLocationService()
        case .denied, .notDetermined:
            stopLocationService()
            DispatchQueue.performUIOperation {
                self.delegate?.didChangePermissionStatus(in: self)
            }
        }
    }
}

extension HomePresenter: LocationServiceDelegate {
    func didRangeCar(car: ClientConfiguration.CarIdentification, with proximity: CLProximity, meters: Double) {
        switch proximity {
        case .unknown:
            view?.display(openButton: true)
            view?.display(carDistance: "Das Fahrzeug befindet sich nicht in der Nähe \(meters)m")
        case .immediate:
            view?.display(openButton: true)
            view?.display(carDistance: "Du bist beinahe am Fahrzeug: \(meters)m")
        case .near:
            view?.display(openButton: true)
            view?.display(carDistance: "Du bist nah am Fahrzeug: \(meters)m")
        case .far:
            view?.display(openButton: true)
            view?.display(carDistance: "Bitte laufe zum Fahrzeug: \(meters)")
        @unknown default:
            fatalError()
        }
    }
    
    func didFail(with error: String, in service: LocationService) {
        print(error)
    }
}

extension HomePresenter: StepEngineControlServiceDelegate {
    func didReceive(message: String, in service: StepEngineControlService) {
        guard let newStepPosition = StepPosition(rawValue: message) else { return }
        view?.display(stepPosition: newStepPosition)
    }
}
