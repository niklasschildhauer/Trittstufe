//
//  InformationView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import UIKit

class InformationView: NibLoadingView {
    
    struct ViewModel {
        let text: String
        let image: UIImage
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
    
    @IBOutlet private weak var backgroundView: RoundedCornerView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    private func reload(with viewModel: ViewModel) {
        label.text = viewModel.text
        imageView.image = viewModel.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHidden = true
        
        label.font = Font.body
    }
}
