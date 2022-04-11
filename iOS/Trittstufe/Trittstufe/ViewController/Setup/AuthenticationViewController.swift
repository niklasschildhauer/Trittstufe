//
//  AuthenticationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var presenter: AuthenticationPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        presenter.didTapLogin()
    }
}

extension AuthenticationViewController: AuthenticationView {
    func setLoginFieldsHiddenStatus(isHidden: Bool) {
        accountNameTextField.isHidden = isHidden
        passwordTextField.isHidden = isHidden
        rememberMeSwitch.isHidden = isHidden
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
            passwordTextField.text
        }
        set {
            passwordTextField.text = newValue
        }
    }
    
    var accountNameValue: String? {
        get {
            accountNameTextField.text
        }
        set {
            accountNameTextField.text = newValue
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
