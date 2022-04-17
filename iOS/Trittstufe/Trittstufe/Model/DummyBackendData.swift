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
    
    struct Car: Codable {
        let model: String
        let vin: String
        let ipAdress: String
        let port: UInt16
        let publicKey: String
        let authorizedUsers: [AuthorizedUser]
    }
    
    struct AuthorizedUser: Codable {
        let userIdentification: String
        let dueDate: String
    }
    
    struct User: Codable {
        let accountName: String
        let password: String
        let userIdentification: String
    }
    
    static func loadFromUserDefaults() -> DummyBackendData? {
        UserDefaultConfig.dummyBackendData
    }
}

