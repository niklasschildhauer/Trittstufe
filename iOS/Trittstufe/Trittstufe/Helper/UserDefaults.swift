//
//  UserDefaults.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

struct UserDefaultConfig {
    @UserDefault(key: "account_name_key", defaultValue: nil)
    private static var accountNameValue: String?
    
    @UserDefault(key: "remember_me_key", defaultValue: false)
    private static var rememberMeValue: Bool
    
    @UserDefault(key: "configuration_ip_adress_key", defaultValue: nil)
    private static var configurationIpAdressValue: String?
}

extension UserDefaultConfig {
    static var accountName: String? {
        get {
            accountNameValue
        }
        set {
            accountNameValue = newValue
        }
    }
    
    static var configurationIpAdress: String? {
        get {
            "123"
        }
        set {
            configurationIpAdressValue = newValue
        }
    }

    static var rememberMe: Bool {
        get {
            rememberMeValue
        }
        set {
            rememberMeValue = newValue
        }
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
