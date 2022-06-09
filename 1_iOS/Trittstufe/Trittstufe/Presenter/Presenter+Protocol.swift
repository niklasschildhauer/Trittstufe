//
//  Presenter+Protocol.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

protocol Presenter {
    associatedtype A
    associatedtype B
    
    var view: A? { get set }
    var delegate: B? { get set }
}
