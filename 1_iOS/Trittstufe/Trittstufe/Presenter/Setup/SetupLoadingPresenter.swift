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

class SetupLoadingPresenter: Presenter {
    weak var view: SetupLoadingView?
    var delegate: SetupLoadingPresenterDelegate?
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func viewDidLoad() {
        delegate?.setupDidAppear(in: self)
    }
}
