//
//  NFCReaderService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 06.06.22.
//

import Foundation
import CoreNFC

/// Delegate which is called when a step was successfully located in the service.
protocol NFCReaderServiceDelegate {
    func didLocate(step: CarStepIdentification, in service: NFCReaderService)
}

/// NFC Reader Service
/// This service class is responsible for reading the NFC tags. It creates a NFCTagReaderSession by which the NDEF message of the tags is read out at startup. Then it checks if the structure of the NDEF message is correct and if the read uuid matches the UUID of the car. Only if this fits the door is selected, which is stored in the NDEF message under stepId.
class NFCReaderService: NSObject {
    
    private var readerSession: NFCTagReaderSession?
    var delegate: NFCReaderServiceDelegate?
    var carId: String = ""
    
    /// Starts the reader and returns if it is possible to start an nfc reader session
    func startReader(toLocate car: String, completion: (Bool) -> Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC reader not available")
            completion(false)
            return
        }
        
        self.carId = car
        readerSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self, queue: nil)
        readerSession?.alertMessage = NSLocalizedString("NFCReaderService_Instruction", comment: "")
        readerSession?.begin()
        completion(true)
    }
    
    private func readNDEF(_ message: NFCNDEFMessage) -> Bool {
        print(message)
        for payload in message.records {
            if let text = payload.wellKnownTypeTextPayload().0,
               let stepIdentification = readStepIdentification(from: text),
               carId == stepIdentification.uuid {
                delegate?.didLocate(step: stepIdentification.stepId, in: self)
                return true
            }
        }
        return false
    }
    
    private struct NDEFStepIdentificationMessage: Codable {
        let uuid: String
        let stepId: CarStepIdentification
    }
    
    private func readStepIdentification(from payload: String) -> NDEFStepIdentificationMessage? {
        return try? JSONDecoder().decode(NDEFStepIdentificationMessage.self, from: payload.data(using: .utf8)!)
    }
}

extension NFCReaderService: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("did Start NFC Reader Session")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("did detect NFC Tag")
        var ndefTag: NFCNDEFTag
        
        switch tags.first! {
        case let .iso7816(tag):
            ndefTag = tag
        case let .feliCa(tag):
            ndefTag = tag
        case let .iso15693(tag):
            ndefTag = tag
        case let .miFare(tag):
            ndefTag = tag
        @unknown default:
            session.invalidate(errorMessage: "Tag not valid.")
            return
        }
        
        session.connect(to: tags.first!) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            
            ndefTag.queryNDEFStatus() { (status: NFCNDEFStatus, _, error: Error?) in
                if status == .notSupported {
                    session.invalidate(errorMessage: "Tag not valid.")
                    return
                }
                ndefTag.readNDEF() { (message: NFCNDEFMessage?, error: Error?) in
                    if error != nil || message == nil {
                        session.invalidate(errorMessage: "Read error. Please try again.")
                        return
                    }
                    
                    if self.readNDEF(message!) {
                        session.alertMessage = "Tag read success."
                        session.invalidate()
                        return
                    }
                    
                    session.invalidate(errorMessage: "Tag not valid.")
                }
            }
        }
    }
}

