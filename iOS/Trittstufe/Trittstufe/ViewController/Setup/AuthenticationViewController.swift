//
//  AuthenticationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
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
         
    }
    
    func showError(message: String) {
         
    }
    
    var passwordValue: String {
        get {
            ""
        }
        set {
             
        }
    }
    
    var accountNameValue: String {
        get {
            ""
        }
        set {
             
        }
    }
    
    var rememberMeValue: Bool {
        get {
            true
        }
        set {
             
        }
    }
}
