//
//  EncryptionHelper.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 04.05.22.
//

import Foundation

struct SignatureHelper {
//    static func encrypt(string: String, publicKey: String?) -> String? {
//        guard let publicKey = publicKey else { return nil }
//        
//        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "")
//        guard let data = Data(base64Encoded: keyString) else { return nil }
//        
//        var attributes: CFDictionary {
//            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
//                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
//                    kSecAttrKeySizeInBits   : 2048,
//                    kSecReturnPersistentRef : kCFBooleanTrue] as! CFDictionary
//        }
//        
//        var error: Unmanaged<CFError>? = nil
//        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
//            print(error.debugDescription)
//            return nil
//        }
//        return encrypt(string: string, publicKey: secKey)
//    }
//    
//    static func encrypt(string: String, publicKey: SecKey) -> String? {
//        let buffer = [UInt8](string.utf8)
//
//        var keySize   = SecKeyGetBlockSize(publicKey)
//        var keyBuffer = [UInt8](repeating: 0, count: keySize)
//
//        // Encrypto  should less than key length
//        guard SecKeyCreateEncryptedData(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
//        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
//    }
}
