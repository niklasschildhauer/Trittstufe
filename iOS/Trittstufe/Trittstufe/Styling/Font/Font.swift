//
//  Font.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 16.04.22.
//

import UIKit

enum Font {
   
//    static var largeTitle: UIFont { custom(for: .largeTitle) }
    static var title: UIFont { custom(for: .title) }
//    static var title2: UIFont { custom(for: .title2) }
//    static var title3: UIFont { custom(for: .title3) }
//    static var headline: UIFont { custom(for: .headline) }
//    static var subheadline: UIFont { custom(for: .subheadline) }
    static var body: UIFont { custom(for: .body, customWeight: .medium) }
    static var bodyBold: UIFont { custom(for: .body, customWeight: .bold) }

//    static var footnote: UIFont { custom(for: .footnote) }
//    static var footnoteBold: UIFont { custom(for: .footnote, customWeight: .semiBold) }
    static var caption: UIFont { custom(for: .caption) }
    static var captionBold: UIFont { custom(for: .caption, customWeight: .semiBold) }

    
    enum TextStyle {
        case body
        case largeTitle
        case title
        case caption
        case footnote
        
        var systemTextStyle: UIFont.TextStyle {
            switch self {
            case .body:
                return .body
            case .largeTitle:
                return .largeTitle
            case .title:
                return .title1
            case .caption:
                return .caption1
            case .footnote:
                return .footnote
            }
        }
    }

    
    static func custom(for textStyle: Font.TextStyle, customWeight: Weight? = nil) -> UIFont {
        guard let descriptor = descriptor(for: textStyle, customWeight: customWeight),
            let font = UIFont(name: descriptor.fontName, size: descriptor.fontSize) else {
                return UIFont.preferredFont(forTextStyle: textStyle.systemTextStyle)
        }
        // TODO: Scale fonts with dynamic text
        return font
    }
    
    enum Weight {
        case medium
        case regular
        case bold
        case black
        case light
        case extraLight
        case semiBold
    }
    
    
    // MARK: Implementation
    private enum InterFont: String {
        case black = "Inter-Black"
        case bold = "Inter-Bold"
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case semiBold = "Inter-SemiBold"
        case light = "Inter-Light"
        case extraLight = "Inter-ExtraLight"
        
        static func font(for weight: Weight) -> InterFont {
            switch weight {
            case .regular:
                return regular
            case .bold:
                return bold
            case .black:
                return black
            case .light:
                return light
            case .semiBold:
                return semiBold
            case .medium:
                return medium
            case .extraLight:
                return extraLight
            }
        }
    }
    
    private struct Descriptor {
        let fontName: String
        let fontSize: CGFloat
    }
    
    private static func descriptor(for textStyle: Font.TextStyle, customWeight: Weight? = nil) -> Descriptor? {
        let textStyleWeight: Weight
        let fontSize: CGFloat
        
        switch textStyle {
        case .body:
            textStyleWeight = .regular
            fontSize = 16
        case .largeTitle:
            textStyleWeight = .bold
            fontSize = 34
        case .title:
            textStyleWeight = .semiBold
            fontSize = 28
        case .caption:
            textStyleWeight = .regular
            fontSize = 11
        case .footnote:
            textStyleWeight = .regular
            fontSize = 13
        }
        
        if let customWeight = customWeight {
            return Descriptor(fontName: InterFont.font(for: customWeight).rawValue,
                              fontSize: fontSize)
        }
        
        return Descriptor(fontName: InterFont.font(for: textStyleWeight).rawValue,
                          fontSize: fontSize)
    }
}

