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
           "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkZS5uaWtsYXNzY2hpbGRoYXVlci50cml0dHN0dWZlIiwiaWF0IjoxNjUzNzMyNTc5LCJleHAiOjE3Nzk5NjI5OTMsImF1ZCI6Ind3dy5oZG0tc3R1dHRnYXJ0LmRlIiwic3ViIjoiVXNlciIsImFjY291bnROYW1lIjoiQW5zZ2FyIn0.TbqXgQv7oi3a2p9rQ5pFBGQ_5j_ZkJ4SUhNBhSwmHko"
        },
        {
           "userToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkZS5uaWtsYXNzY2hpbGRoYXVlci50cml0dHN0dWZlIiwiaWF0IjoxNjUzNzMyNTc5LCJleHAiOjE3Nzk5NjI5OTMsImF1ZCI6Ind3dy5oZG0tc3R1dHRnYXJ0LmRlIiwic3ViIjoiVXNlciIsImFjY291bnROYW1lIjoiTmlrbGFzIn0.nha5Ptxn-Bv0EtHoZYMe5RFZzqRquDHzYIb8RF1zB9I"
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

