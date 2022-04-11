//
//  ConfigurationPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

protocol ConfigurationView: AnyObject {
    var presenter: ConfigurationPresenter! { get set }
    
    var portValue: String? { get set }
    var ipAdressValue: String? { get set }
    var publicKeyValue: String? { get set }

    func showError(message: String)
    func hideError()
}

protocol ConfigurationPresenterDelegate: AnyObject {
    func didCompletecConfiguration(in presenter: ConfigurationPresenter)
}

class ConfigurationPresenter: Presenter {
    weak var view: ConfigurationView?
    weak var delegate: ConfigurationPresenterDelegate?
    
    private let configurationService: ConfigurationService
    
    init(configurationService: ConfigurationService) {
        self.configurationService = configurationService
    }
    
    func viewDidLoad() {
        
    }
    
    func didTapSubmitButton() {
        guard let portValue = view?.portValue,
              portValue != "",
              let ipAdress = view?.ipAdressValue,
              ipAdress != "",
              let publicKey = view?.publicKeyValue,
              publicKey != "" else {
            self.view?.showError(message: "Bitte alles ausfüllen!")
            return
        }
        
        configurationService.port = portValue
        configurationService.ipAdress = ipAdress
        configurationService.publicKey = publicKey

        delegate?.didCompletecConfiguration(in: self)
    }
}
