//
//  CryptoHelper.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 08.05.22.
//

import Foundation
import CryptoKit

struct CryptoHelper {
    public static func generateEncryptedJSONString(payload: String, publicKeyReviever: String) -> String {
        let inputData = Data(payload.utf8)
        
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        let publicKeyReciever = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: publicKeyReviever)!)
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: publicKeyReciever)
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
            salt: "trittstufe-hdm-stuttgart".data(using: .utf8)!,
            sharedInfo: Data(),
            outputByteCount: 32)
        print("Private key  : ", privateKey.rawRepresentation.base64EncodedString())
        print("Public key   : ", publicKey.rawRepresentation.base64EncodedString())
        print("Shared secret: ", sharedSecret.withUnsafeBytes {return Data(Array($0)).base64EncodedString()})
        print("Symmetric key: ", symmetricKey.withUnsafeBytes {return Data(Array($0)).base64EncodedString()})
        
        let sealedBoxData = try! ChaChaPoly.seal(inputData, using: symmetricKey).combined
        print(sealedBoxData.base64EncodedString())
        
        let json: [String: Any] = [
            "publicKey": publicKey.rawRepresentation.base64EncodedString(),
            "payload": sealedBoxData.base64EncodedString()
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        return jsonString
    }
    
}
