//
//  NibLoadableView.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 19.04.22.
//

import UIKit

/* Usage:
- Subclass your UIView from NibLoadView to automatically load an Xib with the same name as your class
- Set the class name to File's Owner in the Xib file
*/

@IBDesignable
class NibLoadingView: UIView {

    @IBOutlet public weak var view: UIView!
    
    private var didLoad: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if !self.didLoad {
            self.didLoad = true
            self.viewDidLoad()
        }    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if !self.didLoad {
            self.didLoad = true
            self.viewDidLoad()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.didLoad {
            self.didLoad = true
            self.viewDidLoad()
        }
    }
    
    open func viewDidLoad() {
        self.nibSetup()
    }

    private func nibSetup() {
        self.view = self.loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(self.view)
    }

    private func loadViewFromNib() -> UIView {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else {
            fatalError("Bad nib name")
        }
        
        if let defaultBundleView = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView {
            return defaultBundleView
        } else {
            fatalError("Cannot load view from bundle")
        }
    }
}
