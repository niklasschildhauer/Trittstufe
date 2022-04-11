//
//  ConfigurationService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 11.04.22.
//

import Foundation

class ConfigurationService {
    var isConfigured: Bool {
        get {
            guard ipAdress != nil, port != nil, publicKey != nil else {
                return false
            }
            return true
        }
    }
    var ipAdress: String? {
        get {
            UserDefaultConfig.configurationIpAdress
        }
        set {
            UserDefaultConfig.configurationIpAdress = newValue
        }
    }
    var port: String? {
        get {
            UserDefaultConfig.configurationPort
        }
        set {
            UserDefaultConfig.configurationPort = newValue
        }
    }
    var publicKey: String? {
        get {
            UserDefaultConfig.configurationPublicKey
        }
        set {
            UserDefaultConfig.configurationPublicKey = newValue
        }
    }
}
