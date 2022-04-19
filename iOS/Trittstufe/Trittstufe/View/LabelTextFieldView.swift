//
//  LabelTextFieldView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 19.04.22.
//

import UIKit

class LabelTextFieldView: NibLoadingView {
    @IBOutlet weak var labelView: NSLayoutConstraint!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var separator: UIView!
    
    @IBInspectable var showSeparator: Bool = false {
        didSet {
            separator.isHidden = !showSeparator
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textFieldView.backgroundColor = .yellow
        
    }
}
