//
//  UserService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 13.04.22.
//

import Foundation

enum AuthenticationError: Error {
    case invalidLoginCredentials
    case noNetwork
    case serverError
}

protocol UserService {
    var userLoggedIn: Bool { get }
    var accountName: String? { get }
    var rememberMe: Bool { get }
    
    func loginWithRememberMe(completion: (Result<String, AuthenticationError>) -> Void)
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<String, AuthenticationError>) -> Void)
    func logout()
}

class LocalUserService: UserService {
    var userLoggedIn: Bool {
        let value = accountName != nil && userIdentification != nil
        return value
    }
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
    private var userIdentification: String?
    private let keychainService: KeychainService
    
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func loginWithRememberMe(completion: (Result<String, AuthenticationError>) -> Void) {
        guard let accountName = accountName, let password = try? keychainService.readPassword(account: accountName) else {
            completion(.failure(.invalidLoginCredentials))
            return
        }
        login(accountName: accountName, password: password, completion: completion)
    }
    
    func login(accountName: String, password: String, rememberMe: Bool, completion: (Result<String, AuthenticationError>) -> Void) {
        self.rememberMe = rememberMe
        
        login(accountName: accountName, password: password, completion: completion)
    }
    
    private func login(accountName: String, password: String, completion: (Result<String, AuthenticationError>) -> Void) {
        userIdentification = "Das ist eine Client ID"
        self.accountName = accountName
        try? keychainService.save(password: password, account: accountName)
        completion(.success("Das ist die CLient ID"))
    }
    
    
    func logout() {
        userIdentification = nil
        try? keychainService.deletePassword(account: accountName ?? "")
        accountName = nil
        rememberMe = false
        userIdentification = nil
    }
    
}
