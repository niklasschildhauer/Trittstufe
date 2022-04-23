//
//  SetupViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class SetupLoadingViewController : UIViewController {
    
    var presenter: SetupLoadingPresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension SetupLoadingViewController : SetupLoadingView {
    
}
