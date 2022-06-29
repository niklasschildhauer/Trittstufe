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
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = Font.title
        titleLabel.text = NSLocalizedString("ConfigurationController_Title", comment: "")
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let barButtonItem =  UIBarButtonItem(title: NSLocalizedString("ConfigurationController_SubmitButton", comment: ""), style: .plain, target: self, action: #selector(didTapSubmitButton))
        
        navigationItem.rightBarButtonItem  = barButtonItem
    }

    private func setupViews() {
        showScannerButton.configuration = ButtonStyle.fullWidth(title: NSLocalizedString("ConfigurationController_QRButton", comment: ""))

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
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    var uuidValue: String? {
        get {
            uuidLabelTextField.textFieldView.text
        }
        set {
            uuidLabelTextField.textFieldView.text = newValue
        }
    }
    
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
}
