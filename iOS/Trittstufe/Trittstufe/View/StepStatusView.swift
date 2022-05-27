//
//  StepStatusView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import UIKit

class StepStatusView: NibLoadingView {
    
    struct ViewModel {
        let selectedSideStatus: CarStepStatus
        let currentStatus: [CarStepStatus]
        
        var currentStatusImage: UIImage {
            let leftStatus: CarStepStatus.Position = currentStatus.first(where: { $0.side == .left })?.position ?? .unknown
            let rightStatus: CarStepStatus.Position = currentStatus.first(where: { $0.side == .right })?.position ?? .unknown

            return UIImage(named: "\(leftStatus.rawValue)-\(rightStatus.rawValue)")!
        }
    }
    @IBOutlet weak var arrowLeftImageView: UIImageView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    @IBOutlet weak var carStatusImageView: UIImageView!
    @IBOutlet weak var swipeButtonView: SwipeButton!
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                isHidden = true
                return
            }

            reload(with: viewModel)
            isHidden = false
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
        switch viewModel.selectedSideStatus.side {
        case .left:
            arrowLeftImageView.isHidden = false
            arrowRightImageView.isHidden = true
        case .right:
            arrowLeftImageView.isHidden = true
            arrowLeftImageView.isHidden = false
        }
        
        carStatusImageView.image = viewModel.currentStatusImage
        
        switch viewModel.selectedSideStatus.position {
        case .close, .open:
            swipeButtonView.isHidden = false
        case .unknown:
            swipeButtonView.isHidden = true
        }
        
        swipeButtonView.stepStatus = viewModel.selectedSideStatus
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
