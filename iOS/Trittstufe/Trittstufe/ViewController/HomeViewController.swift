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
    @IBOutlet weak var stepStatusView: StepStatusView!
    @IBOutlet weak var connectionFailedView: UIView!
    
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
    }
    
    private func setupController() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = Font.title
        titleLabel.text = "Home"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftItemsSupplementBackButton = true
        
        let barButtonItem =  UIBarButtonItem(title: NSLocalizedString("HomeViewController_LogoutButton", comment: ""), style: .plain, target: self, action: #selector(didTapLogoutButton))
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    private func setupViews() {
        
    }
    
    @IBAction func didTapRetryButton(_ sender: Any) {
        presenter.reloadServices()
    }
    
    @objc func didTapLogoutButton() {
        presenter.logout()
    }
    
    @IBAction func didTapActionButton(_ sender: Any) {
        presenter.didTapActionButton()
    }
}

extension HomeViewController: HomeView {
    func show(reconnectButton: Bool) {
        connectionFailedView.isHidden = !reconnectButton
    }
    
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
        stepStatusView.viewModel = viewModel
        stepStatusView.swipeButtonDelegate = self
    }
    
    func display(reconnectButton: Bool) {
        reconnectButton ? retryButton.fadeIn() : retryButton.fadeOut()
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


