//
//  ConfigurationPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit

protocol ConfigurationView: AnyObject, ErrorAlert {
    var presenter: ConfigurationPresenter! { get set }
    
    var portValue: String? { get set }
    var ipAdressValue: String? { get set }
    var publicKeyValue: String? { get set }
    var uuidValue: String? { get set }
    
    func present(_ viewController: UIViewController)
}

protocol ConfigurationPresenterDelegate: AnyObject {
    func didCompletecConfiguration(in presenter: ConfigurationPresenter)
}

/// ConfigurationPresenter
/// The manual configuration allows the user to set the IP address to which a connection to the broker should be established, or which public key should be used for encryption, or which UUID the rented car has. This configuration is unnecessary as soon as a valid backend service provides this information.
/// Todo: Load the configuration from a backend service
class ConfigurationPresenter: Presenter {
    weak var view: ConfigurationView?
    var delegate: ConfigurationPresenterDelegate?
    
    private var dummyBackendData: DummyBackendData?
    
    func viewDidLoad() {
        dummyBackendData = loadDummyDataFromDevice()
        
        guard let dummyBackendData = dummyBackendData else {
            self.view?.showErrorAlert(with: "Ein interner Fehler ist aufgetreten.", title: "Internet Error")
            return
        }
        view?.portValue = String(dummyBackendData.car.port)
        view?.ipAdressValue = dummyBackendData.car.ipAdress
        view?.publicKeyValue = dummyBackendData.car.publicKey
        view?.uuidValue = dummyBackendData.car.uuid
    }
    
    /// Open the QR Code Scanner to read the backend data via QR Code
    func didTapShowQRScannerButton() {
        let viewController  = QRCodeScannerViewController()
        viewController.delegate = self
        
        DispatchQueue.performUIOperation {
            self.view?.present(viewController)
        }
    }
    
    func didTapSubmitButton() {
        guard let portValue = UInt16(view?.portValue ?? ""),
              let ipAdress = view?.ipAdressValue,
              ipAdress != "",
              let publicKey = view?.publicKeyValue,
              publicKey != "",
              let uuidValue = view?.uuidValue,
              uuidValue != "" else {
                self.view?.showErrorAlert(with: "Bitte stelle sicher, dass alle Felder ausgefüllt sind.", title: "Eingabefehler")
            return
        }
        
        if let existingConfiguration = UserDefaultConfig.dummyBackendData {
            let newCarConfiguration = CarBackend(uuid: uuidValue, model: existingConfiguration.car.model, ipAdress: ipAdress, port: portValue, publicKey: publicKey, authorizedUsers: existingConfiguration.car.authorizedUsers, stepIdentifications: existingConfiguration.car.stepIdentifications)
            
            saveDummyBackendData(dummyBackendData: .init(car: newCarConfiguration, users: existingConfiguration.users))
        } else {
            guard let dummyBackendData = dummyBackendData else {
                self.view?.showErrorAlert(with: "Ein interner Fehler ist aufgetreten.", title: "Internal Error")
                return
            }
            let newCarConfiguration = CarBackend(uuid: uuidValue, model: dummyBackendData.car.model, ipAdress: ipAdress, port: portValue, publicKey: publicKey, authorizedUsers: dummyBackendData.car.authorizedUsers, stepIdentifications: dummyBackendData.car.stepIdentifications)
            
            saveDummyBackendData(dummyBackendData: .init(car: newCarConfiguration, users: dummyBackendData.users))
        }
    }
    
    private func saveDummyBackendData(dummyBackendData: DummyBackendData) {
        UserDefaultConfig.dummyBackendData = dummyBackendData
        
        delegate?.didCompletecConfiguration(in: self)
    }
    
    private func loadDummyDataFromDevice() -> DummyBackendData? {
        if let userDefaults = UserDefaultConfig.dummyBackendData {
            return userDefaults
        } else {
            let jsonData = dummyData.data(using: .utf8)!
            let dummyDataEncoded: DummyBackendData? = try! JSONDecoder().decode(DummyBackendData.self, from: jsonData)
            
            return dummyDataEncoded
        }
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

