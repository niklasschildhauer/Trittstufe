//
//  RequestLocationPermissionViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 17.04.22.
//

import UIKit
import CoreLocation

class RequestLocationPermissionViewController: UIViewController {
    
    var presenter: RequestLocationPermissionPresenter? {
        didSet {
            presenter?.view = self
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter?.viewDidLoad()
    }
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
        presenter?.didTapConfirmButton()
    }
}

extension RequestLocationPermissionViewController: RequestLocationPermissionView {
    func showAppWillNotWorkView() {
        confirmButton.isHidden = true
        // TODO
        descriptionLabel.text = "Die App kann ohne Location nicht funktionieren. Bitte gehe in die Einstellungen und schalte die Location frei."
    }
}


// Mark: CLLocationManagerDelegate protocol implementation
extension RequestLocationPermissionViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            presenter?.didDeniedPermission()
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            presenter?.didAuthorizedPermission()
        @unknown default:
            presenter?.didDeniedPermission()
        }
    }
}
