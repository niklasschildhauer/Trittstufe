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
    
        configuration.image = image
        configuration.titleAlignment = .leading
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        
        return configuration
    }
}
