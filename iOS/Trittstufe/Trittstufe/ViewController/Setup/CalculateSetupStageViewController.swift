//
//  SetupViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import UIKit

class CalculateSetupStageViewController: UIViewController {
    
    var presenter: CalculateSetupStagePresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    

}

extension CalculateSetupStageViewController: SetupView {
    
}
