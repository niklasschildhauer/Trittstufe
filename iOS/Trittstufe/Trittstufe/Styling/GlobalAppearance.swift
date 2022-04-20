//
//  UINavigationBar+Extensions.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 20.04.22.
//

import UIKit

struct GlobalAppearancee {
    
    static func styleNavigationBarFonts() {
        let attrs = [
            NSAttributedString.Key.font: Font.bodyBold
        ]
        
        let largeAttrs = [
            NSAttributedString.Key.font: Font.largeTitle
        ]
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = attrs

        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.buttonAppearance = buttonAppearance
        navbarAppearance.largeTitleTextAttributes = largeAttrs
        navbarAppearance.titleTextAttributes = attrs
        
        UINavigationBar.appearance().standardAppearance = navbarAppearance
    }
    
    static let cornerRadius: CGFloat = 20.0
}
