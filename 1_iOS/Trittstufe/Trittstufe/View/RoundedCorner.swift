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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        defer {
            cornerRadius = GlobalAppearance.cornerRadius
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        defer {
            cornerRadius = GlobalAppearance.cornerRadius
        }
    }
    
}
