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
        confirmButton.configuration = ButtonStyle.fullWidth(title: "OK")
        
        titleLabel.text = NSLocalizedString("AuthenticationViewController_Title", comment: "")
        titleLabel.font = Font.title
        
        descriptionLabel.text = NSLocalizedString("AuthenticationViewController_Text1", comment: "")
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
        settingsButton.configuration = ButtonStyle.fullWidth(title: NSLocalizedString("AuthenticationViewController_Settings", comment: ""))
        descriptionLabel.text = NSLocalizedString("AuthenticationViewController_Text2", comment: "")
        
        settingsButton.isHidden = false
        confirmButton.isHidden = true
        
        sheetPresentationController?.animateChanges {
            sheetPresentationController?.detents = [.large()]
        }
    }
}
