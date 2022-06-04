//
//  NetworkService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 15.04.22.
//

import Foundation

protocol NetworkService {
    func loadClientConfiguration(for accountName: String, password: String, completion: (Result<ClientConfiguration, AuthenticationError>) -> Void)
}

class LocalNetworkService: NetworkService {
    func loadClientConfiguration(for accountName: String, password: String, completion: (Result<ClientConfiguration, AuthenticationError>) -> Void) {
        guard let dummyBackendData = UserDefaultConfig.dummyBackendData else {
            completion(.failure(.internalError))
            return
        }
        
        guard let userIdentification = validateCredentials(accountName: accountName, password: password, dummyBackendData: dummyBackendData) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }
        
        // At the moment we only allow to be authorized for one car. Maybe we can change this behaviour in the future
        guard let authorizedCar = loadAuthorizedCar(userToken: userIdentification, dummyBackendData: dummyBackendData) else {
            completion(.failure(.internalError))
            return
        }

        let clientConfiguration = ClientConfiguration(userToken: userIdentification, carIdentification: authorizedCar)
        
        completion(.success(clientConfiguration))
    }
    
    // Todo implement valid backend service
    private func validateCredentials(accountName: String, password: String, dummyBackendData: DummyBackendData) -> String? {
        let knownUsers = dummyBackendData.users
        
        guard let user = knownUsers.filter({ $0.accountName == accountName && $0.password == password }).first else { return nil}
    
        return user.userToken
    }
    
    private func loadAuthorizedCar(userToken: String, dummyBackendData: DummyBackendData) -> CarIdentification? {
        if dummyBackendData.car.authorizedUsers.contains(where: { user in
            user.userToken == userToken
        }) {
            return CarIdentification(id: dummyBackendData.car.id, ipAdress: dummyBackendData.car.ipAdress, portNumber: dummyBackendData.car.port, publicKey: dummyBackendData.car.publicKey, model: dummyBackendData.car.model, stepIdentifications: dummyBackendData.car.stepIdentifications)
        }
        return nil
    }
}



