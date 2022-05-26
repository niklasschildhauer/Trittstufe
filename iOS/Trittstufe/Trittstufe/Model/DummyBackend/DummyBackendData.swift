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
     "beaconId":"05c13100-102b-42cf-babb-ace7dd99c4e3",
     "vin":"123123",
     "ipAdress":"192.9.12.2",
     "port":8338,
     "publicKey":"DasisteinKey",
     "authorizedUsers":[
        {
           "userToken":"11442322",
           "dueDate":"Sonntag"
        },
        {
           "userToken":"12312322",
           "dueDate":"Sonntag"
        }
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
         "password":"Sonnenblume2"
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

