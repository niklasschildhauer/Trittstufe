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
}

protocol HomePresenterDelegate: AnyObject {
    func didTapLogout(in presenter: HomePresenter)
    func didChangePermissionStatus(in presenter: HomePresenter)
}

class HomePresenter: Presenter {
    weak var view: HomeView?
    var delegate: HomePresenterDelegate?
    
    private let stepEngineControlService: StepEngineControlService
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
    }
    
    private func startEngineControlService() {
        stepEngineControlService.connect() { _ in }
    }
    
    private func stopLocationService() {
        locationService.stopMonitoring()
    }
    
    func sendTestMessage() {
        stepEngineControlService.extendStep()
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
    func didFail(with error: String, in service: LocationService) {
        print(error)
    }
    
    func didRangeBeacons(beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
    }
}
