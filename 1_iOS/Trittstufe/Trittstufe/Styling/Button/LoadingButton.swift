//
//  LoadingButton.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 12.06.22.
//

import UIKit

class LoadingButton: UIButton {
    var icon: UIImage?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        icon = image(for: .normal)
        let clearImage = icon?.withTintColor(.clear, renderingMode: .alwaysTemplate)
        setImage(clearImage, for: .normal)
                
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        setImage(icon, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: activityIndicator, attribute: .leading, multiplier: 1, constant: -16)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
