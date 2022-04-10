//
//  ConfigurationViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    var presenter: ConfigurationPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapTestButton(_ sender: Any) {
        presenter.didTapTestButton()
    }
}

extension ConfigurationViewController: ConfigurationView {
    
}
