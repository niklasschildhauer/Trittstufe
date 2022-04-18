//
//  DummyBackendData.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 15.04.22.
//

import Foundation

let dummyData: String = """
{
   "cars":[
      {
         "model":"Rolling Chasis",
         "beaconId":"e339d8b2-7b73-40fd-9c58-44e6b3d1c608",
         "vin":"123123",
         "ipAdress":"192.9.12.2",
         "port":8338,
         "publicKey":"DasisteinKey",
         "authorizedUsers":[
            {
               "userIdentification":"11442322",
               "dueDate":"Sonntag"
            },
            {
               "userIdentification":"12312322",
               "dueDate":"Sonntag"
            }
         ]
      }
   ],
   "users":[
      {
         "accountName":"Niklas",
         "userIdentification":"11442322",
         "password":"Sonnenblume"
      },
      {
         "accountName":"Ansgar",
         "userIdentification":"12312322",
         "password":"Sonnenblume2"
      }
   ]
}
"""

struct DummyBackendData: Codable {
    let cars: [Car]
    let users: [User]
    
    static func loadFromUserDefaults() -> DummyBackendData? {
        UserDefaultConfig.dummyBackendData
    }
}

