//
//  AuthenticationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var logoContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginWrapperView: UIStackView!
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var changeConfigurationButton: UIButton!
    @IBOutlet weak var accountNameLabelTextField: LabelTextFieldView!
    @IBOutlet weak var passwordLabelTextField: LabelTextFieldView!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceIDLabel: UILabel!
    
    var presenter: AuthenticationPresenter! {
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
        titleLabel.text = "Anmelden"
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @IBAction func changeRememberMeValue(_ sender: Any) {
        presenter.didChangeRememberMeValue(newValue: rememberMeValue)
    }
    
    private func setupViews() {
        loginButton.configuration = ButtonStyle.filled(title: NSLocalizedString("AuthenticationController_LoginButton", comment: ""), image: UIImage(systemName: "arrow.forward.circle")!)
        changeConfigurationButton.configuration = ButtonStyle.plain(title: "Konfiguration ändern")
        
        errorMessageLabel.font = Font.bodyBold
        faceIDLabel.font = Font.body
        
        accountNameLabelTextField.labelView.text = "Name"
        passwordLabelTextField.labelView.text = "Passwort"
    }
    
    private func setupKeyboardBehaviour() {
        scrollViewBottomConstraint.isActive = false
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    @IBAction func didTapEditConfigurationButton(_ sender: Any) {
        presenter.didTapEditConfiguration()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        presenter.didTapLogin()
    }
}

extension AuthenticationViewController: AuthenticationView {
    func showLoginSpinner() {
        loginButton.showLoading()
    }
    
    func hideLoginSpinner() {
        loginButton.hideLoading()
    }
    
    func setLoginFieldsHiddenStatus(isHidden: Bool, animated: Bool) {
        if isHidden {
            loginWrapperView.isHidden = isHidden
            logoContainerHeightConstraint.constant = 350
        } else {
            if animated {
                self.logoContainerHeightConstraint.constant = 150
                UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.loginWrapperView.isHidden = isHidden
                }
            } else {
                self.logoContainerHeightConstraint.constant = 150
                self.loginWrapperView.isHidden = isHidden
            }
        }
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
