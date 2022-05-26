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
        var distance: CLProximity
        var image: UIImage
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
        setConstraints(for: viewModel.distance)
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
    
    private func setConstraints(for proximity: CLProximity) {
        let height = frame.height
        let simpleDistance = (height / 2) / 4
        
        
        switch proximity {
        case .unknown:
            carBackgroundView.isHidden = true
        case .immediate:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance * 1.5
            carTopConstraint.constant = simpleDistance * 3.25 - carWidthConstraint.constant
        case .near:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance * 1.25
            carTopConstraint.constant = simpleDistance * 2 - carWidthConstraint.constant
        case .far:
            carBackgroundView.isHidden = false
            carWidthConstraint.constant = simpleDistance
            carTopConstraint.constant = 0
        }        
    }
}
