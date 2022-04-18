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
        
        locationService.startMonitoring()
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
            break
        case .denied, .notDetermined:
            DispatchQueue.performUIOperation {
                self.logout()
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
