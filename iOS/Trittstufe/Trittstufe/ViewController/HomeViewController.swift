//
//  HomeViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var informationView: InformationView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var carHeaderView: CarHeaderView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var distanceView: DistanceView!
    
    var presenter: HomePresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
        
        informationView.viewModel = .init(text: "Test", image: UIImage(systemName: "location")!)
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
        //swipeButton.activeConfiguration = .init(label: "Ausfahren", icon: UIImage(systemName: "lock.open.fill")!)
        
        //swipeButton.deactiveConfiguration = .init(label: "Einfahren", icon: UIImage(systemName: "lock.circle")!)
        
        //swipeButton.delegate = self
        
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    @IBAction func didTapRetryButton(_ sender: Any) {
        presenter.reload()
    }
    
    @objc func didTapLogoutButton() {
        presenter.logout()
    }
    
    @objc func didTapActionButton() {
        presenter.didTapActionButton()
    }
}

extension HomeViewController: HomeView {
    func display(informationView viewModel: InformationView.ViewModel?) {
        informationView.viewModel = viewModel
    }
    
    func display(actionButton viewModel: UIButton.ViewModel?) {
        actionButton.setViewModel(viewModel: viewModel)
    }
    
    func display(distanceView viewModel: DistanceView.ViewModel?, animated: Bool) {
        distanceView.viewModel = viewModel
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.distanceView.layoutIfNeeded()
            }
        }
    }
    
    func display(stepStatusView viewModel: StepStatusView.ViewModel?) {
        //TODO
    }
    
    func display(reconnectButton: Bool) {
        retryButton.isHidden = !reconnectButton
    }
    
    func display(carHeaderView viewModel: CarHeaderView.ViewModel?) {
        carHeaderView.viewModel = viewModel
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


