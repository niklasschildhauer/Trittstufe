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
    func display(retryButton: Bool)
    func display(carHeaderViewModel: CarHeaderView.ViewModel)
}

protocol HomePresenterDelegate: AnyObject {
    func didTapLogout(in presenter: HomePresenter)
    func didChangePermissionStatus(in presenter: HomePresenter)
}

class HomePresenter: Presenter {
    
    struct Status {
        var proximity: CLProximity = .near
        var meters: Double = 2.0
        var connectedToCar: Bool = true
        
        var distanceDescription: String {
            let roundedMeters = Int(meters)
            switch proximity {
            case .unknown:
                return "Das Fahrzeug befindet sich nicht in der Nähe \(roundedMeters)m"
            case .immediate:
                return "Du bist beinahe am Fahrzeug: \(roundedMeters)m"
            case .near:
                return "Du bist nah am Fahrzeug: \(roundedMeters)m"
            case .far:
                return "Bitte laufe zum Fahrzeug: \(roundedMeters)"
            @unknown default:
                fatalError()
            }
        }
        
        var carHeaderViewModel: CarHeaderView.ViewModel {
            .init(carName: "TODO", networkStatus: .init(image: UIImage(systemName: "wifi")!, color: .cyan, text: "Verbunden"), locationStatus: .init(image: UIImage(systemName: "location")!, color: .red, text: "WEIT"))
        }
        
        var showOpenButton: Bool {
            proximity == .unknown ? false : true
        }
    }
    
    weak var view: HomeView?
    var delegate: HomePresenterDelegate?
    
    private var stepEngineControlService: StepEngineControlService
    private let locationService: LocationService
    private var status = Status()
    
    init(stepEngineControlService: StepEngineControlService, locationService: LocationService) {
        self.stepEngineControlService = stepEngineControlService
        self.locationService = locationService
    }
    
    func reload() {
        locationService.statusDelegate = self
        locationService.delegate = self
        
        if locationService.permissionStatus() == .granted {
            startLocationService()
            startEngineControlService()
        } else {
            delegate?.didChangePermissionStatus(in: self)
        }
    }

    func viewWillAppear() {
        reload()
        updateView()
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

    private func updateView() {
        if status.connectedToCar {
            view?.display(retryButton: false)
            view?.display(carDistance: status.distanceDescription)
            view?.display(openButton: status.showOpenButton)
        } else {
            view?.display(openButton: false)
            view?.display(carDistance: "Verbindungsfehler")
            view?.display(retryButton: true)
        }
        
        view?.display(carHeaderViewModel: status.carHeaderViewModel)
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
        status.proximity = proximity
        status.meters = meters
        
        //TODO: Is called very often!
        updateView()
    }
    
    func didFail(with error: String, in service: LocationService) {
        print(error)
    }
}

extension HomePresenter: StepEngineControlServiceDelegate {
    func didConnectToCar(in service: StepEngineControlService) {
        status.connectedToCar = true
        updateView()

    }
    
    func didDisconnectToCar(in service: StepEngineControlService) {
//        status.connectedToCar = false
        updateView()
    }
    
    func didReceive(message: String, in service: StepEngineControlService) {
        guard let newStepPosition = StepPosition(rawValue: message) else { return }
        view?.display(stepPosition: newStepPosition)
    }
}
