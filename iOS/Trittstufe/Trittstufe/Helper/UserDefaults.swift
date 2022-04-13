//
//  UserDefaults.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

struct UserDefaultConfig {
    @NilableUserDefault(key: "account_name_key")
    private static var accountNameValue: String?
    
    @UserDefault(key: "remember_me_key", defaultValue: false)
    private static var rememberMeValue: Bool
    
    @NilableUserDefault(key: "configuration_ip_adress_key")
    private static var configurationIpAdressValue: String?
    
    @NilableUserDefault(key: "configuration_port_key")
    private static var configurationPortValue: UInt16?
    
    @NilableUserDefault(key: "configuration_public_key_key")
    private static var configurationPublicKeyValue: String?
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
    
    static var configurationPort: UInt16? {
        get {
            configurationPortValue
        }
        set {
            configurationPortValue = newValue
        }
    }
    
    static var configurationIpAdress: String? {
        get {
            configurationIpAdressValue
        }
        set {
            configurationIpAdressValue = newValue
        }
    }
    
    static var configurationPublicKey: String? {
        get {
            configurationPublicKeyValue
        }
        set {
            configurationPublicKeyValue = newValue
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

@propertyWrapper
struct NilableUserDefault<Value> {
    let key: String
    var container: UserDefaults = .standard

    var wrappedValue: Value? {
        get {
            return container.object(forKey: key) as? Value ?? nil
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            }
            container.set(newValue, forKey: key)
        }
    }
}
