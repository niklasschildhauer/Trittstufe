//
//  RequestLocationPermissionPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 17.04.22.
//

import Foundation
import CoreLocation

protocol RequestLocationPermissionView: CLLocationManagerDelegate {
    var presenter: RequestLocationPermissionPresenter? { get set }
    
    func showAppWillNotWorkView()
}

protocol RequestLocationPermissionPresenterDelegate {
    func didGrantedPermission(in presenter: RequestLocationPermissionPresenter)
}

class RequestLocationPermissionPresenter {
    weak var view: RequestLocationPermissionView?
    var delegate: RequestLocationPermissionPresenterDelegate?
    
    private let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func viewDidLoad() {
        locationService.statusDelegate = self
        reload()
    }
    
    func reload() {
        switch locationService.permissionStatus() {
        case .granted:
            delegate?.didGrantedPermission(in: self)
        case .denied:
            view?.showAppWillNotWorkView()
        case .notDetermined:
            break
        }
    }
    
    func didTapConfirmButton() {
        locationService.requestAuthorization()
    }
    
    func didDeniedPermission() {
        view?.showAppWillNotWorkView()
    }
    
    func didAuthorizedPermission() {
        delegate?.didGrantedPermission(in: self)
    }
}

extension RequestLocationPermissionPresenter: LocationServiceStatusDelegate {
    func didChangeStatus(in service: LocationService) {
        DispatchQueue.performUIOperation {
            self.reload()
        }
    }
}
