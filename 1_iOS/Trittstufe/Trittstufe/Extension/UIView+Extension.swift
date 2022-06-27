//
//  UIView+Extension.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 28.05.22.
//

import Foundation
import UIKit

/// Fade in and out animation
extension UIView {
    func fadeIn(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        if isHidden == true {
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: duration!,
                           animations: { self.alpha = 1 },
                           completion: { (value: Bool) in
                if let complete = onCompletion { complete() }
            }
            )
        }
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        if isHidden == false {
            
            UIView.animate(withDuration: duration!,
                           animations: { self.alpha = 0 },
                           completion: { (value: Bool) in
                self.isHidden = true
                if let complete = onCompletion { complete() }
            }
            )
        }
    }
}
