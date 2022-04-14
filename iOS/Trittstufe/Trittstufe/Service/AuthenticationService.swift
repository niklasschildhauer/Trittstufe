//
//  AuthenticationService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 13.04.22.
//

import Foundation

enum AuthenticationError: Error {
    case invalidLoginCredentials
    case noNetwork
    case internalError
    case serverError
}

protocol AuthenticationService {
    var clientConfiguration: ClientConfiguration? { get }
    var accountName: String? { get }
    var rememberMe: Bool { get }
    
    func loginWithRememberMe(completion: (Result<ClientConfiguration, AuthenticationError>) -> Void)
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<ClientConfiguration, AuthenticationError>) -> Void)
    func logout()
}

class LocalAuthenticationService: AuthenticationService {
    var clientConfiguration: ClientConfiguration? = nil
    var accountName: String? {
        get {
            UserDefaultConfig.accountName
        }
        set {
            UserDefaultConfig.accountName = newValue
        }
    }
    var rememberMe: Bool {
        get {
            UserDefaultConfig.rememberMe
        }
        set {
            UserDefaultConfig.rememberMe = newValue
        }
    }
    private let keychainService: KeychainService
    
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func loginWithRememberMe(completion: (Result<ClientConfiguration, AuthenticationError>) -> Void) {
        guard let accountName = accountName, let password = try? keychainService.readPassword(account: accountName) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }
        login(accountName: accountName, password: password, completion: completion)
    }
    
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<ClientConfiguration, AuthenticationError>) -> Void) {
        self.rememberMe = rememberMe
        
        login(accountName: accountName, password: password, completion: completion)
    }
    
    private func login(accountName: String, password: String, completion: (Result<ClientConfiguration, AuthenticationError>) -> Void) {
        guard let userIdentification = validateCredentials(accountName: accountName, password: password) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }
        
        guard let hostIdentification = ClientConfiguration.HostIdentification.loadFromUserDefaults() else {
            completion(.failure(.internalError))
            return
        }

        self.accountName = accountName
        try? keychainService.save(password: password, account: accountName)
        
        let clientCredentials = ClientConfiguration.ClientCredentials(userIdentification: userIdentification, accountName: accountName, password: password)
        
        clientConfiguration = ClientConfiguration(clientCredentials: clientCredentials, hostIdentification: hostIdentification)
        
        completion(.success(clientConfiguration!))
    }
    
    // Todo implement valid backend service
    private func validateCredentials(accountName: String, password: String) -> String? {
        let knownUsers = ["Niklas":"Sonnenblume"]
        
        let index = knownUsers.index(forKey: accountName)
        if let index = index {
            if knownUsers[index].value == password {
                return userIdentification(for: accountName)
            }
        }
        
        return nil
    }
    
    // Todo implement valid backend service
    private func userIdentification(for accountName: String) -> String {
        return "1234756789"
    }
    
    
    func logout() {
        clientConfiguration = nil
        try? keychainService.deletePassword(account: accountName ?? "")
        accountName = nil
        rememberMe = false
    }
    
}
