//
//  StepStatusView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import UIKit

class StepStatusView: NibLoadingView {
    
    struct ViewModel {
        let selectedStep: CarStepIdentification
        let currentStatus: [CarStepStatus]
        
        var currentStatusImage: UIImage {
            let leftStatus: CarStepStatus.Position = currentStatus.first(where: { $0.step == .left })?.position ?? .unknown
            let rightStatus: CarStepStatus.Position = currentStatus.first(where: { $0.step == .right })?.position ?? .unknown

            return UIImage(named: "\(leftStatus.imageName)-\(rightStatus.imageName)")!
        }
        
        var selectedStepStatus: CarStepStatus? {
            currentStatus.first(where: { $0.step == selectedStep })
        }
    }
    @IBOutlet weak var arrowLeftImageView: UIImageView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    @IBOutlet weak var carStatusImageView: UIImageView!
    @IBOutlet weak var swipeButtonView: SwipeButton!
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                fadeOut()
                return
            }

            reload(with: viewModel)
            fadeIn()
        }
    }
    
    var swipeButtonDelegate: SwipeButtonDelegate? {
        get {
            swipeButtonView.delegate
        }
        set {
            swipeButtonView.delegate = newValue
        }
    }

    private func reload(with viewModel: ViewModel) {
        switch viewModel.selectedStep {
        case .left:
            arrowLeftImageView.isHidden = true
            arrowRightImageView.isHidden = false
        case .right:
            arrowLeftImageView.isHidden = false
            arrowRightImageView.isHidden = true
        case .unknown:
            arrowLeftImageView.isHidden = true
            arrowRightImageView.isHidden = true
        }
        
        carStatusImageView.image = viewModel.currentStatusImage
        guard let selectedStepStatus = viewModel.selectedStepStatus else {
            swipeButtonView.isHidden = true
            return
        }
        
        switch selectedStepStatus.position {
        case .close, .open:
            swipeButtonView.isHidden = false
        case .unknown:
            swipeButtonView.isHidden = true
        }
        
        swipeButtonView.stepStatus = selectedStepStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let viewModel = viewModel else {
            return
        }

        reload(with: viewModel)
    }

}
