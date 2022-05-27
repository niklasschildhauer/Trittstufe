//
//  CarStatus.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import Foundation
import CoreLocation
import UIKit

struct CarStatus {
    var car: CarIdentification
    var proximity: CLProximity = .near
    var meters: Double = 2.0
    var connectedToCar: Bool = true
    let stepStatus: [CarStepStatus]
    
    init(car: CarIdentification) {
        self.car = car
        stepStatus = car.steps.map {CarStepStatus(stepIdentification: $0) }
    }
    
    enum state {
        case notConnected
        case inLocalization(proximity: CLProximity, description: String)
        case localizedStep(stepStatus: CarStepStatus)
    }
    
    var distanceDescription: String {
        let roundedMeters = Int(meters)
        switch proximity {
        case .unknown:
            return "Das Fahrzeug befindet sich nicht in der Nähe \(roundedMeters)m"
        case .immediate:
            return "Du bist beinahe am Fahrzeug: \(roundedMeters)m"
        case .near:
            return "Du bist nah am Fahrzeug: \(roundedMeters)m"
        case .far:
            return "Bitte laufe zum Fahrzeug: \(roundedMeters)"
        @unknown default:
            fatalError()
        }
    }
    
    var carHeaderViewModel: CarHeaderView.ViewModel {
        .init(carName: "TODO", networkStatus: .init(image: UIImage(systemName: "wifi")!, color: .cyan, text: "Verbunden"), locationStatus: .init(image: UIImage(systemName: "location")!, color: .red, text: "WEIT"))
    }
    
    var showOpenButton: Bool {
        proximity == .unknown ? false : true
    }
}


struct CarStepStatus {
    enum Position: String, Codable {
        case open
        case close
        case unknown
    }
    
    let stepIdentification: CarStepIdentification
    var position: Position = .unknown
}
