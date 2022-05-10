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
    private let buttonWidth: CGFloat = 80
    private var deactivatePosition: CGFloat {
        view.frame.width  - buttonWidth/2 - 6
    }
    private var activatePosition: CGFloat {
        buttonWidth/2
    }
    private let tolerance: CGFloat = 15.0

    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dragViewLeadingAnchor: NSLayoutConstraint!
    var delegate: SwipeButtonDelegate?
    var initialCenter = CGPoint()
    var buttonState: ButtonState = .deactivated {
        didSet {
            if oldValue != buttonState {
                setNewPosition(buttonState: buttonState)
            }
        }
    }
    var activeConfiguration: Configuration? { 
        didSet {
            reloadConfiguration()
        }
    }
    var deactiveConfiguration: Configuration? {
        didSet {
            reloadConfiguration()
        }
    }

    enum ButtonState {
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
            let generator = UINotificationFeedbackGenerator()

            switch buttonState {
            case .deactivated:
                if currentCenter.x >= (deactivatePosition - tolerance) {
                    buttonState = .activated
                    delegate?.didActivate(in: self)
                    initialCenter = CGPoint(x: activatePosition, y: initialCenter.y)
                    generator.notificationOccurred(.success)

                    return
                }
            case .activated:
                if currentCenter.x <= (activatePosition + tolerance) {
                    buttonState = .deactivated
                    delegate?.didDeactivate(in: self)
                    initialCenter = CGPoint(x: deactivatePosition, y: initialCenter.y)
                    generator.notificationOccurred(.error)
                    
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
    
    private func setNewPosition(buttonState: ButtonState) {
        switch buttonState {
        case .deactivated:
            guard let activeConfiguration = activeConfiguration else {
                return
            }
            set(configuration: activeConfiguration)
            dragViewLeadingAnchor.constant = 0


        case .activated:
            guard let deactiveConfiguration = deactiveConfiguration else {
                return
            }
            set(configuration: deactiveConfiguration)
            dragViewLeadingAnchor.constant = deactivatePosition - buttonWidth/2
        }
    }
    
    private func reloadConfiguration() {
        switch buttonState {
        case .activated:
            guard let deactiveConfiguration = deactiveConfiguration else {
                return
            }
            set(configuration: deactiveConfiguration)
        case .deactivated:
            guard let activeConfiguration = activeConfiguration else {
                return
            }
            set(configuration: activeConfiguration)
        }
    }
    
    private func set(configuration: Configuration) {
        UIView.transition(with: self.iconImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.iconImageView.image = configuration.icon
        })
    }
}
