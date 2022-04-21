//
//  ConfigurationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var showScannerButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
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
        setupController()
        setupViews()
        setupKeyboardBehaviour()
    
        presenter.viewDidLoad()
    }
    
    private func setupController() {
//        navigationItem.title = "Konfiguration"
//        navigationController?.navigationBar.prefersLargeTitles = true
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = Font.title
        titleLabel.text = "Konfiguration"
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let submitButton = UIButton()
        submitButton.configuration = ButtonStyle.filled(title: "Bestätigen", image: UIImage(systemName: "checkmark.circle")!)
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: submitButton)
        navigationItem.rightBarButtonItem  = barButtonItem
    }

    private func setupViews() {
        showScannerButton.configuration = ButtonStyle.fullWidth(title: "QR-Scanner öffnen")

        
        ipAdressLabelTextField.labelView.text = "IP Adresse"
        portLabelTextField.labelView.text = "Port"
        publicKeyLabelTextField.labelView.text = "Public Key"
        uuidLabelTextField.labelView.text = "UUID"
        descriptionLabel.text = NSLocalizedString("ConfigurationViewController_Description", comment: "")
        descriptionLabel.font = Font.body
    }
    
    private func setupKeyboardBehaviour() {
        bottomConstraint.isActive = false
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        
        
    }
    
    @IBAction func didTapShowQRCodeSacnnerButton(_ sender: Any) {
        presenter.didTapShowQRScannerButton()
    }
    
    @objc func didTapSubmitButton() {
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
