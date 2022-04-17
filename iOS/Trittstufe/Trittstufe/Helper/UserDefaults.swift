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
    
    @NilableUserDefault(key: "dummy_backend_data_key")
    private static var dummyBackendDataValue: String?
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
    
    static var dummyBackendData: DummyBackendData? {
        get {
            guard let dummyBackendDataJSON = dummyBackendDataValue?.data(using: .utf8),
                  let dummyBackendData = try? JSONDecoder().decode(DummyBackendData.self, from: dummyBackendDataJSON)
            else { return nil }
            
            return dummyBackendData
        }
        set {
            guard let dummyBackendDataJSON = try? JSONEncoder().encode(newValue) else { return }
            dummyBackendDataValue = String(decoding: dummyBackendDataJSON, as: UTF8.self)
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
