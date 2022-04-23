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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    
        presenter?.viewDidLoad()
    }
    
    private func setupViews() {
        confirmButton.configuration = ButtonStyle.fullWidth(title: "Verstanden")
        
        titleLabel.text = "Standortfreigabe"
        titleLabel.font = Font.title
        
        descriptionLabel.text = "Die App benötigt Ihren Standort, zum lokalisieren des Rolling-Chassis. Aus diesem Grund bitten wir um Freigabe des Standorts."
        descriptionLabel.font = Font.body
    }
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
        presenter?.didTapConfirmButton()
    }
    
    @IBAction func didTapSettingsButton(_ sender: Any) {
        presenter?.didTapOpenSettingsButton()
    }
    
}

extension RequestLocationPermissionViewController: RequestLocationPermissionView {
    func showAppWillNotWorkView() {
        settingsButton.titleLabel?.text = "Einstellungen öffnen"
        descriptionLabel.text = "Die App kann ohne Standortfreigabe nicht funktionieren. Bitte gehen Sie in die Einstellungen und geben den Standort frei."
        
        settingsButton.isHidden = false
        confirmButton.isHidden = true
        
        sheetPresentationController?.animateChanges {
            sheetPresentationController?.detents = [.large()]
        }
    }
}
