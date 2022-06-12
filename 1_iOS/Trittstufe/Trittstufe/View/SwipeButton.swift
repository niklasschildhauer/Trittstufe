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
    private var lockedPosition: CGFloat {
        view.frame.width - buttonWidth/2 - 6
    }
    private var unlockedPosition: CGFloat {
        buttonWidth/2
    }
    private let tolerance: CGFloat = 15.0

    @IBOutlet weak var labelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dragViewLeadingAnchor: NSLayoutConstraint!
    var delegate: SwipeButtonDelegate?
    var initialCenter = CGPoint()
    var stepStatus: CarStepStatus = .init(step: .left, position: .unknown) {
        didSet {
            if oldValue != stepStatus {
                reload()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reload()
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
            
            if newCenter.x < unlockedPosition {
                newCenter.x = unlockedPosition
            }
            
            if newCenter.x > lockedPosition {
                newCenter.x = lockedPosition
            }
            
            piece.center = newCenter
        case .ended, .cancelled, .failed:
            let currentCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
            let generator = UINotificationFeedbackGenerator()

            switch stepStatus.position {
            case .close:
                if currentCenter.x >= (lockedPosition - tolerance) {
                    stepStatus.position = .open
                    delegate?.didActivate(in: self)
                    initialCenter = CGPoint(x: unlockedPosition, y: initialCenter.y)
                    generator.notificationOccurred(.success)

                    return
                }
            case .open:
                if currentCenter.x <= (unlockedPosition + tolerance) {
                    stepStatus.position = .close
                    delegate?.didDeactivate(in: self)
                    initialCenter = CGPoint(x: lockedPosition, y: initialCenter.y)
                    generator.notificationOccurred(.error)
                    
                    return
                }
            case .unknown:
                break
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

    
    private func reload() {
        UIView.transition(with: self.iconImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            switch self.stepStatus.position  {
            case .close:
                self.dragViewLeadingAnchor.constant = 0

                self.iconImageView.image = UIImage(systemName: "lock")
                self.label.text = "\(self.stepStatus.step.name) Treppe ausfahren"
                self.labelCenterConstraint.constant = 20
            case .open:
                self.dragViewLeadingAnchor.constant = self.lockedPosition - self.buttonWidth/2

                self.iconImageView.image = UIImage(systemName: "lock.open")
                self.label.text = "\(self.stepStatus.step.name) Treppe einfahren"
                self.labelCenterConstraint.constant = -20

            case .unknown:
                self.label.text = ""
                self.iconImageView.image = nil
            }
        })
       
    }
}
