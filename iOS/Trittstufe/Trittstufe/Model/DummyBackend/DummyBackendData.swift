//
//  DummyBackendData.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 15.04.22.
//

import Foundation

let dummyData: String = """
{
   "car": {
     "model":"Rolling Chasis",
     "ipAdress":"169.254.222.28",
     "port":1883,
     "publicKey":"XWOVfM+MFrs26wdQntzXUjatvN/CJvDQ47sd/LZ1YwQ=",
     "authorizedUsers":[
        {
           "userToken":"11442322"
        },
        {
           "userToken":"12312322"
        }
     ],
     "steps": [
        {
            "beaconId":"05c13100-102b-42cf-babb-ace7dd99c4e3",
            "nfcTokenId":"unkown",
            "side":"left"
        },
        {
            "beaconId":"05c13100-102b-42cf-babb-ace7dd99c4e1",
            "nfcTokenId":"unkown",
            "side":"right"
        },
     ]
    },
   "users":[
      {
         "accountName":"Niklas",
         "userToken":"11442322",
         "password":"Sonnenblume"
      },
      {
         "accountName":"Ansgar",
         "userToken":"12312322",
         "password":"Sonnenblume"
      }
   ]
}
"""

struct DummyBackendData: Codable {
    let car: CarBackend
    let users: [UserBackend]
    
    static func loadFromUserDefaults() -> DummyBackendData? {
        UserDefaultConfig.dummyBackendData
    }
}

