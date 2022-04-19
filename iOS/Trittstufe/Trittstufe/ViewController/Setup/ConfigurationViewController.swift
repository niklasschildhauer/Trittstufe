//
//  ConfigurationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var ipAdressLabelTextField: LabelTextFieldView!
    @IBOutlet weak var portLabelTextField: LabelTextFieldView!
    @IBOutlet weak var publicKeyLabelTextField: LabelTextFieldView!
    @IBOutlet weak var uuidLabelTextField: LabelTextFieldView!
    
    var presenter: ConfigurationPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    private func setupView() {
//        ipAdressLabelTextField.labelView.text = "IP Adresse"
//        portLabelTextField.labelView.text = "Port"
//        publicKeyLabelTextField.labelView.text = "Public Key"
//        uuidLabelTextField.labelView.text = "UUID"
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
            portLabelTextField.textFieldView.text
        }
        set {
            portLabelTextField.textFieldView.text = newValue

        }
    }
    
    var ipAdressValue: String? {
        get {
            ipAdressLabelTextField.textFieldView.text
        }
        set {
            ipAdressLabelTextField.textFieldView.text = newValue
        }
    }
    
    var publicKeyValue: String? {
        get {
            publicKeyLabelTextField.textFieldView.text
        }
        set {
            publicKeyLabelTextField.textFieldView.text = newValue
        }
    }
    
    func showError(message: String) {
        /// TODO
    }
    
    func hideError() {
        ///Todo
    }
}
