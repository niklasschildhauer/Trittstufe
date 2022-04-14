//
//  ClientConfiguration.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 14.04.22.
//

import Foundation

struct ClientConfiguration {
    let clientCredentials: ClientCredentials
    let hostIdentification: HostIdentification
    
    struct HostIdentification {
        let ipAdress: String
        let portNumber: UInt16
        let publicKey: String
        
        static func loadFromUserDefaults() -> HostIdentification? {
            guard let ipAdress = UserDefaultConfig.configurationIpAdress,
                  let portNumber = UserDefaultConfig.configurationPort,
                  let publicKey = UserDefaultConfig.configurationPublicKey else { return nil }
            
            return HostIdentification(ipAdress: ipAdress, portNumber: portNumber, publicKey: publicKey)
        }
    }
    
    struct ClientCredentials {
        let userIdentification: String
        
        // User name and password to log in to the mqtt broker
        let accountName: String // Maybe we don't need this in the future
        let password: String
    }
}
