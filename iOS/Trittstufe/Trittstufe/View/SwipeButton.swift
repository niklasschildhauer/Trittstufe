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
    var delegate: SwipeButtonDelegate?
    var initialCenter = CGPoint()
    var buttonState: State = .deactivated
    
    enum State {
        case activated
        case deactivated
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
                    initialCenter = CGPoint(x: activatePosition, y: initialCenter.y)
                    return
                }
            case .activated:
                if currentCenter.x <= activatePosition  {
                    buttonState = .deactivated
                    initialCenter = CGPoint(x: deactivatePosition, y: initialCenter.y)
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
    
}
