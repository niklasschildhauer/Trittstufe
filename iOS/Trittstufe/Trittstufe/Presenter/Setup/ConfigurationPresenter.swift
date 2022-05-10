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
        let jsonData = dummyData.data(using: .utf8)!
        let dummyDataEncoded: DummyBackendData = try! JSONDecoder().decode(DummyBackendData.self, from: jsonData)
        print(dummyDataEncoded)
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
            let newCarConfiguration = Car(model: existingConfiguration.car.model,
                                          beaconId: existingConfiguration.car.beaconId,
                                          vin: existingConfiguration.car.model,
                                          ipAdress: ipAdress,
                                          port: portValue,
                                          publicKey: publicKey,
                                          authorizedUsers: existingConfiguration.car.authorizedUsers)
            
            saveDummyBackendData(dummyBackendData: .init(car: newCarConfiguration, users: existingConfiguration.users))
        } else {
            let configuration = DummyBackendData(
                car: .init(model: "Rolling Chasis",
                          vin: "123123",
                          ipAdress: ipAdress,
                          port: portValue,
                          publicKey: publicKey,
                          authorizedUsers: [
                            .init(userToken: "testtest", dueDate: "forever")
                          ]),
                users: [
                    .init(accountName: "test",
                          password: "test",
                          userToken: "testtest")
                ]
            )
            
            saveDummyBackendData(dummyBackendData: configuration)
        }
    }
    
    private func saveDummyBackendData(dummyBackendData: DummyBackendData) {
        UserDefaultConfig.dummyBackendData = dummyBackendData
        
        delegate?.didCompletecConfiguration(in: self)
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

