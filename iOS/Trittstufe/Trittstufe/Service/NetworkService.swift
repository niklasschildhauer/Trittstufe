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
        guard let authorizedCar = loadAuthorizedCars(userIdentification: userIdentification, dummyBackendData: dummyBackendData).first else {
            completion(.failure(.internalError))
            return
        }

        let clientConfiguration = ClientConfiguration(userIdentification: userIdentification, carIdentification: authorizedCar)
        
        completion(.success(clientConfiguration))
    }
    
    // Todo implement valid backend service
    private func validateCredentials(accountName: String, password: String, dummyBackendData: DummyBackendData) -> String? {
        let knownUsers = dummyBackendData.users
        
        guard let user = knownUsers.filter({ $0.accountName == accountName && $0.password == password }).first else { return nil}
    
        return user.userIdentification
    }
    
    private func loadAuthorizedCars(userIdentification: String, dummyBackendData: DummyBackendData) -> [ClientConfiguration.CarIdentification] {
        return dummyBackendData.cars.filter { car in
            car.authorizedUsers.contains { user in
                user.userIdentification == userIdentification
            }
        }.map { car in
            ClientConfiguration.CarIdentification(ipAdress: car.ipAdress, portNumber: car.port, publicKey: car.publicKey, model: car.model, vin: car.vin, beaconId: car.beaconId)
        }
    }
}



