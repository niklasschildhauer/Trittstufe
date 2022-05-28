//
//  DistanceView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import UIKit
import CoreLocation

class DistanceView: NibLoadingView {
    
    struct ViewModel {
        var position: Position
        var image: UIImage
        
        enum Position {
            case far
            case middle
            case close
            case unknown
        }
    }
    
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
    @IBOutlet weak var carBackgroundView: UIView!
    @IBOutlet weak var carWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carTopConstraint: NSLayoutConstraint!
    
    private func reload(with viewModel: ViewModel) {
        setConstraints(for: viewModel.position)
        carImageView.image = viewModel.image
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
    
    private func setConstraints(for position: ViewModel.Position) {
        let height = frame.height
        let simpleDistance = (height / 2) / 4
        
        
        switch position {
        case .close:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance * 1.5
            carTopConstraint.constant = simpleDistance * 3.25 - carWidthConstraint.constant
        case .middle:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance * 1.25
            carTopConstraint.constant = simpleDistance * 2 - carWidthConstraint.constant
        case .far:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance
            carTopConstraint.constant = 0
        case .unknown:
            carBackgroundView.isHidden = true
        }        
    }
}
