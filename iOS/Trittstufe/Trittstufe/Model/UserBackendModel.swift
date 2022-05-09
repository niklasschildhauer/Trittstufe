//
//  User.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 18.04.22.
//

import Foundation

struct User: Codable {
    let accountName: String
    let password: String
    let userToken: String
}
