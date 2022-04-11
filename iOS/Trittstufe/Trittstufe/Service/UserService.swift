//
//  UserService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 11.04.22.
//

import Foundation

class UserService {
    
    enum AuthenticationError: Error {
        case invalidLoginCredentials
        case noNetwork
        case serverError
    }
    
    private var userIdentificationValue: String?
    var userLoggedIn = false
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
    
    func loginWithRememberMe(completion: (Result<String, AuthenticationError>) -> Void) {
        guard let accountName = accountName, let password = try? keychainService.readPassword(account: accountName) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }

        login(accountName: accountName, password: password, rememberMe: true, completion: completion)
    }
        
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<String, AuthenticationError>) -> Void) {
        self.rememberMe = rememberMe
        
        
        // success case
        self.accountName = accountName
        if rememberMe {
            try? keychainService.save(password: password, account: accountName)
        }
        
        userLoggedIn = true
        completion(.success("UserIDString"))
    }
    
    func logout() {
        userIdentificationValue = nil
        accountName = nil
    }
    
}
