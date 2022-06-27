//
//  SetupPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

protocol SetupLoadingView: AnyObject {
    var presenter: SetupLoadingPresenter! { get set }
}

protocol SetupLoadingPresenterDelegate: AnyObject {
    func setupDidAppear(in presenter: SetupLoadingPresenter)
}

/// SetupLoadingPresenter
/// Informs the coordinator that the view is loaded. Afterwards the setup calucalation can start. 
class SetupLoadingPresenter: Presenter {
    weak var view: SetupLoadingView?
    var delegate: SetupLoadingPresenterDelegate?
    
    func viewDidLoad() {
        delegate?.setupDidAppear(in: self)
    }
}
