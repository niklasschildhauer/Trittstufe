//
//  AuthenticationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginWrapperView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var changeConfigurationButton: UIButton!
    @IBOutlet weak var accountNameLabelTextField: LabelTextFieldView!
    @IBOutlet weak var passwordLabelTextField: LabelTextFieldView!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var presenter: AuthenticationPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupViews()
        
        presenter.viewDidLoad()
    }
    
    private func setupController() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = Font.title
        titleLabel.text = "Anmelden"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonDisplayMode = .minimal

        navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupViews() {
        loginButton.configuration = ButtonStyle.plain(title: "Anmelden")
    }
    
    @IBAction func didTapEditConfigurationButton(_ sender: Any) {
        presenter.didTapEditConfiguration()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        presenter.didTapLogin()
    }
}

extension AuthenticationViewController: AuthenticationView {
    func setLoginFieldsHiddenStatus(isHidden: Bool) {
        loginWrapperView.isHidden = isHidden
    }
    
    func showError(message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
    
    func hideError() {
        errorMessageLabel.isHidden = true
        errorMessageLabel.text = ""
    }
    
    var passwordValue: String? {
        get {
            passwordLabelTextField.textFieldView.text
        }
        set {
            passwordLabelTextField.textFieldView.text = newValue
        }
    }
    
    var accountNameValue: String? {
        get {
            accountNameLabelTextField.textFieldView.text
        }
        set {
            accountNameLabelTextField.textFieldView.text = newValue
        }
    }
    
    var rememberMeValue: Bool {
        get {
            rememberMeSwitch.isOn
        }
        set {
            rememberMeSwitch.isOn = newValue
        }
    }
}
