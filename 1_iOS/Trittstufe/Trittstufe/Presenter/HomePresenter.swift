//
//  HomePresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit
import CoreLocation
import CoreNFC

protocol HomeView: AnyObject {
    var presenter: HomePresenter! { get set }
    
    func show(reconnectButton: Bool)
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

class HomePresenter: NSObject, Presenter {
    
    weak var view: HomeView?
    var delegate: HomePresenterDelegate?
    
    private var stepEngineControlService: StepEngineControlService
    private let locationService: LocationService
    private var carStatus: CarStatus
    private let nfcReaderService = NFCReaderService()
    
    init(stepEngineControlService: StepEngineControlService, locationService: LocationService, carIdentification: CarIdentification) {
        self.stepEngineControlService = stepEngineControlService
        self.locationService = locationService
        self.carStatus = CarStatus(car: carIdentification)
    }
    
    func reloadServices() {
        if locationService.permissionStatus() == .granted {
            startLocationService()
            startEngineControlService()
        } else {
            delegate?.didChangePermissionStatus(in: self)
        }
    }
    
    func viewWillAppear() {
        reloadServices()
        reloadView()
    }
    
    private func startLocationService() {
        locationService.statusDelegate = self
        locationService.delegate = self
        
        locationService.startMonitoring()
    }
    
    private func startEngineControlService() {
        stepEngineControlService.connect() { _ in }
        stepEngineControlService.statusDelegate = self
    }
    
    private func stopLocationService() {
        locationService.stopMonitoring()
    }
    
    func extendStep() {
        let step = carStatus.selectedStep.step
        stepEngineControlService.extend(step: step)
    }
    
    func shrinkStep() {
        let step = carStatus.selectedStep.step
        stepEngineControlService.shrink(step: step)
    }
    
    func logout() {
        delegate?.didTapLogout(in: self)
    }
    
    func didTapActionButton() {
        switch carStatus.currentState {
        case .notConnected:
            carStatus.connected = true
            reloadView()
            print("Konfiguration")
        case .inLocalization, .readyToUnlock:
            nfcReaderService.delegate = self
            nfcReaderService.startReader(toLocate: carStatus.car.id)
        }
    }
    
    private func reloadView(animated: Bool = false) {
        view?.display(carHeaderView: carStatus.carHeaderViewModel)
        view?.display(stepStatusView: carStatus.stepStatusViewModel)
        view?.display(actionButton: carStatus.actionButtonViewModel)
        view?.display(informationView: carStatus.informationViewModel)
        view?.display(distanceView: carStatus.distanceViewModel, animated: animated)
        view?.show(reconnectButton: carStatus.currentState == .notConnected)
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
    func didRangeNothing(in service: LocationService) {
        guard !carStatus.selectedStep.forceLocated else { return }

        print("Nothing to find")
        carStatus.distance = (proximity: .unknown, meters: nil, count: 0)
        carStatus.selectedStep = (step: .unknown, forceLocated: false)
        
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
    
    func didRangeCar(car: CarIdentification, step: CarStepIdentification, with proximity: CLProximity, meters: Double, in service: LocationService) {
        guard !carStatus.selectedStep.forceLocated else { return }
    
        print("Find: \(car.model), \(step), \(meters)m - \(proximity.rawValue)")

        let distanceCount = carStatus.distance.proximity == proximity ? carStatus.distance.count + 1 : 0
        carStatus.distance = (proximity: proximity, meters: meters > 0 ? meters : nil, count: distanceCount)

        if proximity != .far && carStatus.distance.count > 3 {
            carStatus.selectedStep = (step: step, forceLocated: false)
        }
        
        if proximity == .far && carStatus.distance.count > 6 {
            carStatus.selectedStep = (step: .unknown, forceLocated: false)
        }
        
        DispatchQueue.performUIOperation {
            self.reloadView(animated: true)
        }
    }
        
    func didFail(with error: String, in service: LocationService) {
        carStatus.distance = (proximity: .unknown, meters: nil, count: 0)
        print(error)
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
}

extension HomePresenter: StepEngineControlServiceDelegate {
    func didReceive(stepStatus: CarStepStatus, in service: StepEngineControlService) {
        carStatus.update(stepStatus: stepStatus)
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
    
    func didConnectToCar(in service: StepEngineControlService) {
        carStatus.connected = true
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
    
    func didDisconnectToCar(in service: StepEngineControlService) {
        carStatus.connected = false
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
}

extension HomePresenter: NFCReaderServiceDelegate {
    func didLocate(step: CarStepIdentification, in service: NFCReaderService) {
        carStatus.selectedStep = (step: step, forceLocated: true)
        DispatchQueue.performUIOperation {
            self.reloadView()
        }
    }
}
