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
     "model":"Rolling Chassis",
     "ipAdress":"169.254.222.28",
     "port":1883,
     "publicKey":"XWOVfM+MFrs26wdQntzXUjatvN/CJvDQ47sd/LZ1YwQ=",
     "authorizedUsers":[
        {
           "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6IkFuc2dhciJ9.Rjt1PCOsae8KB4pIIzhMigdEKc6Gxx1K0h1tfklalIQ"
        },
        {
           "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6Ik5pa2xhcyJ9.Ylkw5vN_vWO9y7fDtBEZ6ozA4QosH7u_TtGj6kvwE64"
        }
     ],
     "steps": [
        {
            "uid":"05c13100-102b-42cf-babb-ace7dd99c4e3",
            "side":"left"
        },
        {
            "uid":"6C820B8E-324C-4443-BF4E-FBB71EF73004",
            "side":"right"
        },
     ]
    },
   "users":[
      {
         "accountName":"Ansgar",
         "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6IkFuc2dhciJ9.Rjt1PCOsae8KB4pIIzhMigdEKc6Gxx1K0h1tfklalIQ",
         "password":"Sonnenblume"
      },
      {
         "accountName":"Niklas",
         "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50TmFtZSI6Ik5pa2xhcyJ9.Ylkw5vN_vWO9y7fDtBEZ6ozA4QosH7u_TtGj6kvwE64",
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

