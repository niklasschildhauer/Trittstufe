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
    func didTapShowQRCodeScanner(in presenter: ConfigurationPresenter)
}

class ConfigurationPresenter: Presenter {
    weak var view: ConfigurationView?
    var delegate: ConfigurationPresenterDelegate?
        
    func viewDidLoad() {
        
    }
    
    func didTapShowQRScannerButton() {
        delegate?.didTapShowQRCodeScanner(in: self)
    }
    
    func didTapSubmitButton() {
        guard let portValue = UInt16(view?.portValue ?? ""),
              let ipAdress = view?.ipAdressValue,
              ipAdress != "",
              let publicKey = view?.publicKeyValue,
              publicKey != "" else {
            self.view?.showError(message: "Bitte alles ausfüllen!")
            return
        }
        
        UserDefaultConfig.configurationPublicKey = publicKey
        UserDefaultConfig.configurationPort = portValue
        UserDefaultConfig.configurationIpAdress = ipAdress

        delegate?.didCompletecConfiguration(in: self)
    }
}

extension ConfigurationPresenter: QRCodeScannerDelegate {
    func didScan(code: String, in viewController: QRCodeScannerViewController) {
        print(code)
    }
}

