//
//  ConfigurationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var ipAdressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var publicKeyTextField: UITextField!
    
    var presenter: ConfigurationPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapShowQRCodeSacnnerButton(_ sender: Any) {
        presenter.didTapShowQRScannerButton()
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        presenter.didTapSubmitButton()
    }
}

extension ConfigurationViewController: ConfigurationView {
    var portValue: String? {
        get {
            portTextField.text
        }
        set {
            portTextField.text = newValue

        }
    }
    
    var ipAdressValue: String? {
        get {
            ipAdressTextField.text
        }
        set {
            ipAdressTextField.text = newValue
        }
    }
    
    var publicKeyValue: String? {
        get {
            publicKeyTextField.text
        }
        set {
            publicKeyTextField.text = newValue
        }
    }
    
    func showError(message: String) {
        /// TODO
    }
    
    func hideError() {
        ///Todo
    }
}
