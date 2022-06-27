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
    private let networkService: NetworkService
    
    init(keychainService: KeychainService, networkService: NetworkService) {
        self.networkService = networkService
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
        networkService.loadClientConfiguration(for: accountName, password: password) { result in
            switch result {
            case .success(let clientConfiguration):
                self.accountName = accountName
                try? self.keychainService.save(password: password, account: accountName)
                self.clientConfiguration = clientConfiguration
                
                completion(.success(clientConfiguration))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    func logout() {
        clientConfiguration = nil
        try? keychainService.deletePassword(account: accountName ?? "")
        accountName = nil
        rememberMe = false
    }
}
