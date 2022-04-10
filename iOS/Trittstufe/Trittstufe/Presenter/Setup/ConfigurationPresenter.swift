//
//  ConfigurationPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

protocol ConfigurationView: AnyObject {
    var presenter: ConfigurationPresenter! { get set }
}

protocol ConfigurationPresenterDelegate: AnyObject {
    func didCompletecConfiguration(in presenter: ConfigurationPresenter)
}

class ConfigurationPresenter: Presenter {
    weak var view: ConfigurationView?
    weak var delegate: ConfigurationPresenterDelegate?
    
    func viewDidLoad() {
        
    }
    
    func didTapTestButton() {
        delegate?.didCompletecConfiguration(in: self)
    }
}
