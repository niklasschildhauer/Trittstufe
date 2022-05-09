//
//  EncryptionHelper.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 04.05.22.
//

import Foundation
import CryptoKit

struct SignatureHelper {
    public static func createCipherText(string: String) -> String {
        let inputData = Data(string.utf8)
//        let key256 = SymmetricKey(size: .bits256)
//        let keyString = key256.withUnsafeBytes { Data($0) }.base64EncodedString()
//        print(keyString)
//
//
//        let sealedBoxData = try! ChaChaPoly.seal(inputData, using: key256).combined
//        print(sealedBoxData.base64EncodedString())
//        let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
//
//        let string = String(data: try! ChaChaPoly.open(sealedBox, using: key256), encoding: .utf8)
//        print(string!)

        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        let publicKeyServer = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: "XWOVfM+MFrs26wdQntzXUjatvN/CJvDQ47sd/LZ1YwQ=")!)
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: publicKeyServer)
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
            salt: "a test salt".data(using: .utf8)!,
            sharedInfo: Data(),
            outputByteCount: 32)
        print("Private key  : ", privateKey.rawRepresentation.base64EncodedString())
        print("Public key   : ", publicKey.rawRepresentation.base64EncodedString())
        print("Shared secret: ", sharedSecret.withUnsafeBytes {return Data(Array($0)).base64EncodedString()})
        print("Symmetric key: ", symmetricKey.withUnsafeBytes {return Data(Array($0)).base64EncodedString()})
        
        
        
    

//        let sealedBox2 = try! ChaChaPoly.SealedBox(combined: sealedBoxData2)
//
//        let string2 = String(data: try! ChaChaPoly.open(sealedBox2, using: symmetricKey), encoding: .utf8)
//        print(string2!)
        
        return "Hallo"
    }
    
    public static func addSignature(string: String, car publicKey: String) -> String {
        let message = removeWhiteSpace(string: string)
        print("Message to hash: \(message)")
        let hashedMessage = hash(string: message)
        let signature = encrypt(string: hashedMessage, car: publicKey)

        if let signature = signature {
            return buildJsonString(message: message, signature: signature)
        } else {
            print("------encrytion failed------")
            return message
        }
    }
    
    private static func removeWhiteSpace(string: String) -> String {
        return String(string.filter { !" \n\t\r".contains($0) })
    }
    
    private static func hash(string: String) -> String {
        let inputData = Data(string.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashedMessage = hashed.compactMap { String(format: "%02x", $0) }.joined()
        print("Hashed message: \(hashedMessage)")
        return hashedMessage
    }
    
    private static func buildJsonString(message: String, signature: String) -> String {
        var message = message
        message.remove(at:  message.index(message.endIndex, offsetBy: -1))
        if(message[message.index(message.endIndex, offsetBy: -2)] != ",") {
            message.append(",")
        }
        message.append("\"signature\":\"\(signature)\"}")
        return message
    }
    
    private static func encrypt(string: String, car publicKey: String) -> String? {
        print("-----InEncryption-----")
        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "")
        print("KeyString: "+keyString)
        guard let data = Data(base64Encoded: keyString) else { return nil }
        print("Data is good")
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 512,
                    kSecReturnPersistentRef : kCFBooleanTrue as Any] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print("Encryption Error"+error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }
    
    private static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        print("in encrypt")
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        print("encrypt does return data")
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
