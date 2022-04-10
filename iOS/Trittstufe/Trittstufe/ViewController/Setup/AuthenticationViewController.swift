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
        presenter.didTapTestLogin()
    }
}

extension AuthenticationViewController: AuthenticationView {
    

}
