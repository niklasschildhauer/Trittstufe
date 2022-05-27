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
    
    private var dummyBackendData: DummyBackendData?
    
    func viewDidLoad() {
        dummyBackendData = loadDummyDataFromDevice()
        
        guard let dummyBackendData = dummyBackendData else {
            self.view?.showError(message: "Ein interner Fehler ist aufgetreten.")
            return
        }
        view?.portValue = String(dummyBackendData.car.port)
        view?.ipAdressValue = dummyBackendData.car.ipAdress
        view?.publicKeyValue = dummyBackendData.car.publicKey
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
        
        
        if let existingConfiguration = UserDefaultConfig.dummyBackendData {
            let newCarConfiguration = CarBackend(model: existingConfiguration.car.model, ipAdress: ipAdress, port: portValue, publicKey: publicKey, authorizedUsers: existingConfiguration.car.authorizedUsers, steps: existingConfiguration.car.steps)
            
            saveDummyBackendData(dummyBackendData: .init(car: newCarConfiguration, users: existingConfiguration.users))
        } else {
            guard let dummyBackendData = dummyBackendData else {
                self.view?.showError(message: "Ein interner Fehler ist aufgetreten.")
                return
            }
            let newCarConfiguration = CarBackend(model: dummyBackendData.car.model, ipAdress: ipAdress, port: portValue, publicKey: publicKey, authorizedUsers: dummyBackendData.car.authorizedUsers, steps: dummyBackendData.car.steps)
            
            saveDummyBackendData(dummyBackendData: .init(car: newCarConfiguration, users: dummyBackendData.users))
        }
    }
    
    private func saveDummyBackendData(dummyBackendData: DummyBackendData) {
        UserDefaultConfig.dummyBackendData = dummyBackendData
        
        delegate?.didCompletecConfiguration(in: self)
    }
    
    private func loadDummyDataFromDevice() -> DummyBackendData? {
        let jsonData = dummyData.data(using: .utf8)!
        let dummyDataEncoded: DummyBackendData? = try! JSONDecoder().decode(DummyBackendData.self, from: jsonData)
        
        return dummyDataEncoded
    }
}

extension ConfigurationPresenter: QRCodeScannerDelegate {
    func didScan(code: String, in viewController: QRCodeScannerViewController) {
        guard let dummyBackendDataJSON = code.data(using: .utf8),
              let dummyBackendData = try? JSONDecoder().decode(DummyBackendData.self, from: dummyBackendDataJSON)
        else { return }
        
        saveDummyBackendData(dummyBackendData: dummyBackendData)
    }
}

