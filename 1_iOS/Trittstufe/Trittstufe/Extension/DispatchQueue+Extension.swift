//
//  DispatchQueue.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit

/// Async and sync execution
public extension DispatchQueue {
    static func performUIOperation(execute workItem: @escaping () -> Void ) {
        if Thread.isMainThread {
            workItem()
        } else {
            DispatchQueue.main.async(execute: workItem)
        }
    }
    
    static func scheduleOnMainThread(execute workItem: @escaping () -> Void ) {
        if !Thread.isMainThread {
            workItem()
        } else {
            DispatchQueue.main.async {
                workItem()
            }
        }
    }
}
