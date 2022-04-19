//
//  RoundedCorner.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 19.04.22.
//

import UIKit

class RoundedCornerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
