//
//  HomeViewController.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomePresenter! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        
        createSwipeButton()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        presenter.logout()
    }
    
    @IBAction func didTapSendTestMessage(_ sender: Any) {
        presenter.sendTestMessage()
    }
}

extension HomeViewController: HomeView {
    
}

extension HomeViewController {
    func createSwipeButton() {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.brown
        button.setTitle("PLACE ORDER", for: .normal)
        button.frame = CGRect.init(x: 10, y: 200, width: self.view.frame.size.width-20, height: 100)
        button.addTarget(self, action: #selector(swiped(_:event:)), for: .touchDragInside)
        button.addTarget(self, action: #selector(swipeEnded(_:event:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        let swipableView = UIImageView.init()
        swipableView.frame = CGRect.init(x: 0, y: 0, width: 20, height: button.frame.size.height)
        swipableView.tag = 20
        swipableView.backgroundColor = UIColor.white
        button.addSubview(swipableView)
    }
    
    @objc func swiped(_ sender : UIButton, event: UIEvent) {
        let swipableView = sender.viewWithTag(20)!
        let centerPosition = location(event: event, subView: swipableView, superView: sender,isSwiping: true)
        UIView.animate(withDuration: 0.2) {
            swipableView.center = centerPosition
        }
    }
    
    @objc func swipeEnded(_ sender : UIButton, event: UIEvent) {
        let swipableView = sender.viewWithTag(20)!
        let centerPosition = location(event: event, subView: swipableView, superView: sender, isSwiping: false)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            swipableView.center = centerPosition
        }) { _ in}
    }
    
    func location(event: UIEvent, subView: UIView, superView: UIButton, isSwiping: Bool) -> CGPoint {
        if let touch = event.touches(for: superView)?.first{
            let previousLocation = touch.previousLocation(in: superView)
            let location = touch.location(in: superView)
            let delta_x = location.x - previousLocation.x;
            print(subView.center.x + delta_x)
            var centerPosition = CGPoint.init(x: subView.center.x + delta_x, y: subView.center.y)
            let minX = subView.frame.size.width/2
            let maxX = superView.frame.size.width - subView.frame.size.width/2
            centerPosition.x = centerPosition.x < minX ? minX : centerPosition.x
            centerPosition.x = centerPosition.x > maxX ? maxX : centerPosition.x
            if !isSwiping{
                let normalPosition = superView.frame.size.width * 0.5
                centerPosition.x = centerPosition.x > normalPosition ? maxX : minX
                centerPosition.x = centerPosition.x <= normalPosition ? minX : centerPosition.x
            }
            return centerPosition
        }
        return CGPoint.zero
    }
}
