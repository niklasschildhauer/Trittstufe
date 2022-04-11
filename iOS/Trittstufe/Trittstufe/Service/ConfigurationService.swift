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
            UserDefaultConfig.configurationIpAdress != nil
        }
    }
}
