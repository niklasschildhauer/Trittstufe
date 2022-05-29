//
//  User.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 18.04.22.
//

import Foundation

struct UserBackend: Codable {
    let accountName: String
    let password: String
    let userToken: String
}
