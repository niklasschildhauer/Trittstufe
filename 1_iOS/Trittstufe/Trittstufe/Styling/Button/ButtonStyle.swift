//
//  Button.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 20.04.22.
//

import UIKit

struct ButtonStyle {
    private var bodyFontAttribute: [NSAttributedString.Key:Any] {
        return [
            NSAttributedString.Key.font: Font.bodyBold
        ]
    }
    
    static func plain(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        
        var attributedString = AttributedString(title)
        attributedString.font = Font.bodyBold
        
        configuration.attributedTitle = attributedString
        
        return configuration
    }
    
    static func fullWidth(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        
        var attributedString = AttributedString(title)
        attributedString.font = Font.bodyBold
        
        configuration.attributedTitle = attributedString
        configuration.baseBackgroundColor = Color.black
        configuration.baseForegroundColor = Color.white
        
        configuration.buttonSize = .large
        configuration.cornerStyle = .dynamic
        configuration.background.cornerRadius = GlobalAppearance.cornerRadius
        
        return configuration
    }
    
    static func filled(title: String, image: UIImage, size: UIButton.Configuration.Size = .medium) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        
        var attributedString = AttributedString(title)
        attributedString.font = Font.bodyBold
        
        configuration.attributedTitle = attributedString
        
        configuration.buttonSize = size
        configuration.baseBackgroundColor = Color.black
        configuration.baseForegroundColor = Color.white
        
        configuration.image = image
        configuration.titleAlignment = .leading
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        
        configuration.cornerStyle = .large
        
        return configuration
    }
}

public extension UIButton {
    enum ViewModel {
        case filled(title: String, image: UIImage, size: UIButton.Configuration.Size = .medium)
        case fullWidth(title: String)
        case plain(title: String)
    }
    
    func setViewModel(viewModel: ViewModel?) {
        guard let viewModel = viewModel else {
            isHidden = true
            return
        }
        
        switch viewModel {
        case .filled(let title, let image, let size):
            configuration = ButtonStyle.filled(title: title, image: image, size: size)
        case .fullWidth(let title):
            configuration = ButtonStyle.fullWidth(title: title)
        case .plain(let title):
            configuration = ButtonStyle.plain(title: title)
        }
        
        isHidden = false
    }
}

