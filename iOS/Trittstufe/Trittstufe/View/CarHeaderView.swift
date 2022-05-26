//
//  CarHeaderView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 25.05.22.
//

import UIKit

class CarHeaderView: NibLoadingView {
    
    struct ViewModel {
        let carName: String
        let networkStatus: TagStatusModel
        let locationStatus: TagStatusModel
        
        struct TagStatusModel {
            var image: UIImage
            var color: UIColor
            var text: String
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
    
    @IBOutlet private weak var yourCarLabel: UILabel!
    @IBOutlet private weak var carNameLabel: UILabel!
    
    @IBOutlet private weak var networkStatusBackgroundView: RoundedCornerView!
    @IBOutlet private weak var networkStatusImageView: UIImageView!
    @IBOutlet private weak var networkStatusLabel: UILabel!
    
    @IBOutlet private weak var locationStatusBackgroundView: RoundedCornerView!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!
    
    private func reload(with viewModel: ViewModel) {
        carNameLabel.text = viewModel.carName
        
        networkStatusBackgroundView.backgroundColor = viewModel.networkStatus.color
        networkStatusImageView.image = viewModel.networkStatus.image
        networkStatusLabel.text = viewModel.networkStatus.text.uppercased()
        
        locationStatusBackgroundView.backgroundColor = viewModel.locationStatus.color
        locationImageView.image = viewModel.locationStatus.image
        locationLabel.text = viewModel.locationStatus.text.uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHidden = true
    
        yourCarLabel.font = Font.caption
        carNameLabel.font = Font.bodyBold
        
        locationLabel.font = Font.caption
        networkStatusLabel.font = Font.caption
    }
    
}

