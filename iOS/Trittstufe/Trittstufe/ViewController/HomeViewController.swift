//
//  HomeViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var swipeButton: SwipeButton!
    @IBOutlet weak var distanceLabel: UILabel!
    var presenter: HomePresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupController()

        presenter.viewDidLoad()
    }
    
    private func setupController() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = Font.title
        titleLabel.text = "Home"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftItemsSupplementBackButton = true
        
        let logoutButton = UIButton()
        logoutButton.configuration = ButtonStyle.filled(title: "Abmelden", image: UIImage(systemName: "figure.wave")!)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    private func setupViews() {
        swipeButton.activeConfiguration = .init(label: "Ausfahren", icon: UIImage(systemName: "lock.open.fill")!)
        
        swipeButton.deactiveConfiguration = .init(label: "Einfahren", icon: UIImage(systemName: "lock.circle")!)
        
        swipeButton.delegate = self
    }
    
    @objc func didTapLogoutButton() {
        presenter.logout()
    }
}

extension HomeViewController: HomeView {
    func display(carDistance: String) {
        distanceLabel.text = carDistance
    }
    
    func display(openButton: Bool) {
        swipeButton.isHidden = !openButton
    }
}

extension HomeViewController: SwipeButtonDelegate {
    func didActivate(in swipeButton: SwipeButton) {
        presenter.extendStep()
    }
    
    func didDeactivate(in swipeButton: SwipeButton) {
        presenter.shrinkStep()
    }
}


