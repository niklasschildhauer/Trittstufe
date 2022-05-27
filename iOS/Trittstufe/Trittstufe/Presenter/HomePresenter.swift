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
    
    func display(reconnectButton: Bool)
    func display(carHeaderView viewModel: CarHeaderView.ViewModel?)
    func display(actionButton viewModel: UIButton.ViewModel?)
    func display(distanceView viewModel: DistanceView.ViewModel?, animated: Bool)
    func display(stepStatusView viewModel: StepStatusView.ViewModel?)
    func display(informationView viewModel: InformationView.ViewModel?)
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
    private var carStatus: CarStatus
    
    init(stepEngineControlService: StepEngineControlService, locationService: LocationService, carIdentification: CarIdentification) {
        self.stepEngineControlService = stepEngineControlService
        self.locationService = locationService
        self.carStatus = CarStatus(car: carIdentification)
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
        
        //TODO:
        view?.display(distanceView: .init(distance: .immediate, image: UIImage(named: "distance-car-image")!), animated: false)
        view?.display(actionButton: .filled(title: "Beteis am Fahrzeug?", image: UIImage(systemName: "location")!, size: .medium))
    }
    
    private func startLocationService() {
        locationService.startMonitoring()
        
        //view?.display(openButton: false)
    }
    
    private func startEngineControlService() {
        stepEngineControlService.connect() { _ in }
        stepEngineControlService.statusDelegate = self
    }
    
    private func stopLocationService() {
        locationService.stopMonitoring()
    }
    
    func extendStep(on side: CarStepIdentification.Side) {
        stepEngineControlService.extendStep(on: side)
    }
    
    func shrinkStep(on side: CarStepIdentification.Side) {
        stepEngineControlService.shrinkStep(on: side)
    }
    
    func logout() {
        view?.display(distanceView: .init(distance: .far, image: UIImage(named:"distance-car-image")!), animated: true)
        view?.display(informationView: .init(text: "Bitte gehe näher zum Fahrzeug", image: UIImage(systemName: "location")!))
//        delegate?.didTapLogout(in: self)
    }
    
    func didTapActionButton() {
        view?.display(distanceView: .init(distance: .near, image: UIImage(named: "distance-car-image")!), animated: true)
        view?.display(informationView: nil)
    }

    private func updateView() {
        if carStatus.connectedToCar {
            //view?.display(retryButton: false)
            //view?.display(carDistance: status.distanceDescription)
            //view?.display(openButton: status.showOpenButton)
        } else {
            //view?.display(openButton: false)
            //view?.display(carDistance: "Verbindungsfehler")
            //view?.display(retryButton: true)
        }
        
        view?.display(carHeaderView: carStatus.carHeaderViewModel)
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
    func didRangeCar(car: CarIdentification, with proximity: CLProximity, meters: Double) {
        carStatus.proximity = proximity
        carStatus.meters = meters
        
        //TODO: Is called very often!
        updateView()
    }
    
    func didFail(with error: String, in service: LocationService) {
        print(error)
    }
}

extension HomePresenter: StepEngineControlServiceDelegate {
    func didReceive(stepStatus: [CarStepStatus], in service: StepEngineControlService) {
        print(stepStatus)
    }
    
    func didConnectToCar(in service: StepEngineControlService) {
        carStatus.connectedToCar = true
        updateView()

    }
    
    func didDisconnectToCar(in service: StepEngineControlService) {
//        status.connectedToCar = false
        updateView()
    }
}
