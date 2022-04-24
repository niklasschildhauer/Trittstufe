//
//  SwipeButton.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 24.04.22.
//

import UIKit

protocol SwipeButtonDelegate {
    func didActivate(in swipeButton: SwipeButton)
    func didDeactivate(in swipeButton: SwipeButton)
}

class SwipeButton: NibLoadingView {
    private let width: CGFloat = 80
    private var deactivatePosition: CGFloat {
        view.frame.width  - width/2
    }
    private var activatePosition: CGFloat {
        width/2
    }

    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dragViewLeadingAnchor: NSLayoutConstraint!
    var delegate: SwipeButtonDelegate?
    var initialCenter = CGPoint()
    var buttonState: State = .deactivated
    var activeConfiguration: Configuration?
    var deactiveConfiguration: Configuration?

    enum State {
        case activated
        case deactivated
    }
    
    struct Configuration {
        let label: String
        let icon: UIImage
    }
    
    @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: piece.superview)
        
        switch gestureRecognizer.state {
        case .possible:
            break
        case .began:
            self.initialCenter = piece.center
        case .changed:
            var newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
            
            if newCenter.x < activatePosition {
                newCenter.x = activatePosition
            }
            
            if newCenter.x > deactivatePosition {
                newCenter.x = deactivatePosition
            }
            
            piece.center = newCenter
        case .ended, .cancelled, .failed:
            let currentCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)

            switch buttonState {
            case .deactivated:
                if currentCenter.x >= deactivatePosition {
                    buttonState = .activated
                    delegate?.didActivate(in: self)
                    initialCenter = CGPoint(x: activatePosition, y: initialCenter.y)
                    dragViewLeadingAnchor.constant = deactivatePosition - width/2
                    
                    guard let activeConfiguration = activeConfiguration else {
                        return
                    }
                    set(configuration: activeConfiguration)
                    return
                }
            case .activated:
                if currentCenter.x <= activatePosition  {
                    buttonState = .deactivated
                    delegate?.didDeactivate(in: self)
                    initialCenter = CGPoint(x: deactivatePosition, y: initialCenter.y)
                    dragViewLeadingAnchor.constant = 0
                    
                    guard let deactiveConfiguration = deactiveConfiguration else {
                        return
                    }
                    set(configuration: deactiveConfiguration)
                    return
                }
            }
            
            if piece.center != self.initialCenter {
                UIView.animate(withDuration: 0.5, delay: 0) {
                    piece.center = self.initialCenter
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    private func set(configuration: Configuration) {
        label.text = configuration.label
        iconImageView.image = configuration.icon
    }
}
