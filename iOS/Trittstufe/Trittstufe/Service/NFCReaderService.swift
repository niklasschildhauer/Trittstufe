//
//  NFCReaderService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 06.06.22.
//

import Foundation
import CoreNFC

class NFCReaderService: NSObject {
    
    private var readerSession: NFCTagReaderSession?

    
    func startReader() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC reader not available")
            return
        }
        
        readerSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693, .iso18092], delegate: self, queue: nil)
        readerSession?.alertMessage = "Hold your iPhone near an NFC fish tag."
        readerSession?.begin()
    }
    
}

extension NFCReaderService: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("did becom active")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("did invalidate with error")
        print(error.localizedDescription)

    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("did detect")

    }
}

