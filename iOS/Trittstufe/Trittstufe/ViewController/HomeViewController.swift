//
//  HomeViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomePresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
    
    @IBAction func didTapSendTestMessage(_ sender: Any) {
        presenter.sendTestMessage()
    }
}

extension HomeViewController: HomeView {
    
}
