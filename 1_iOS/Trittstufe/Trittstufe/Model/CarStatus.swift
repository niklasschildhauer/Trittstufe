//
//  CarStatus.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//  Modified by Ansgar Gerlicher on 11.07.22
//

import Foundation
import CoreLocation
import UIKit

/// CarStatus provides the current state of the rented car. It is the source of truth whether the app is connected to the broker, how far the distance to the car is, whether a step has already been identified and keeps the current status of the steps.
struct CarStatus {
    
  
    
    var car: CarIdentification
    var connected: Bool = false
    /// Counter is needed to allow a certain amount of inaccuracy
    var distance: (proximity: CLProximity, meters: Double?, count: Int) = (proximity: .unknown, meters: nil, count: 0)
    var stepStatus: [CarStepStatus]
    /// if force located the step was identified through NFC Scan.
    var selectedStep: (step: CarStepIdentification, forceLocated: Bool) = (step: .unknown, forceLocated: false)
    var currentState: CarState {
        // if not connected, show retry button
        guard connected else {
            return .notConnected
        }
        // if no side is selected show localization screen
        guard selectedStep.step != .unknown else {
            return .inLocalization
        }
        // if side is selected and forceLocated is true, then show unlock screen
        guard !selectedStep.forceLocated else {
            return .readyToUnlock
        }
        // if proximimty is far with a count of 6, then show localization screen
        if distance.meters ?? 2 > 1.0,
           distance.proximity == .unknown || distance.proximity == .far,
           distance.count > 6 {
            return .inLocalization
        }
        return .readyToUnlock
    }
    
    init(car: CarIdentification) {
        self.car = car
        stepStatus = car.stepIdentifications.map { CarStepStatus(step: $0) }
    }
    
    enum CarState {

        case notConnected
        case inLocalization
        case readyToUnlock
    }
    
    mutating func update(stepStatus: CarStepStatus) {
        for statusIndex in self.stepStatus.indices {
            if self.stepStatus[statusIndex].step == stepStatus.step {
                self.stepStatus[statusIndex].position = stepStatus.position
            }
        }
    }
    
    
    // MARK: View Models
    // CarHeaderView.ViewModel.TagStatusModel
    private var locationTag: CarHeaderView.ViewModel.TagStatusModel {
        guard let meters = distance.meters?.rounded() else {
            return .init(image: UIImage(systemName: "location.slash")!, color: Color.statusRed, text: "?")
        }
        
        switch meters {
        case 0..<2:
            return .init(image: UIImage(systemName: "location")!, color: Color.statusGreen, text: "\(Int(meters))m")
        case 2..<5:
            return .init(image: UIImage(systemName: "location")!, color: Color.statusYellow, text: "\(Int(meters))m")
        default:
            return .init(image: UIImage(systemName: "location")!, color: Color.statusRed, text: "\(Int(meters))m")
        }
    }
    
    // CarHeaderView.ViewModel.TagStatusModel
    private var networkTag: CarHeaderView.ViewModel.TagStatusModel {
        switch currentState {
        case .notConnected:
            return .init(image: UIImage(systemName: "wifi.slash")!, color: Color.statusRed, text: "offline".uppercased())
        case .inLocalization, .readyToUnlock:
            return .init(image: UIImage(systemName: "wifi")!, color: Color.statusGreen, text: "online".uppercased())
        }
    }
    
    // CarHeaderView.ViewModel
    var carHeaderViewModel: CarHeaderView.ViewModel {
        .init(carName: car.model, networkStatus: networkTag, locationStatus: locationTag)
    }
    
    // InformationView.ViewModel
    var informationViewModel: InformationView.ViewModel? {
        switch currentState {
        case .notConnected:
            return .init(text: NSLocalizedString("HomeViewController_InformationView_NotConnected", comment: ""), image: .init(systemName: "info.circle")!)
        case .inLocalization:
            return .init(text: NSLocalizedString("HomeViewController_InformationView_InLocalization", comment: ""), image: .init(systemName: "info.circle")!)
        case .readyToUnlock:
            return nil /// if nil then the view will be hidden
        }
    }
    
    // DistanceView.ViewModel
    var distanceViewModel: DistanceView.ViewModel? {
        switch currentState {
        case .notConnected, .readyToUnlock:
            return nil /// if nil then the view will be hidden
        case .inLocalization:
            guard let meters = distance.meters?.rounded() else {
                return .init(position: .unknown, image: car.image)
            }
            switch meters {
            case 0..<2:
                return .init(position: .close, image: car.image)
            case 2..<5:
                return .init(position: .middle, image: car.image)
            default:
                return .init(position: .far, image: car.image)
            }
        }
    }
    
    // StepStatusView.ViewModel
    var stepStatusViewModel: StepStatusView.ViewModel? {
        switch currentState {
        case .notConnected,. inLocalization:
            return nil /// if nil then the view will be hidden
        case .readyToUnlock:
            return .init(selectedStep: selectedStep.step, currentStatus: stepStatus)
        }
    }
    
    // UIButton.ViewModel
    var actionButtonViewModel: UIButton.ViewModel? {
        switch currentState {
        case .notConnected:
            return .filled(title: NSLocalizedString("HomeViewController_ActionButton_NotConnected", comment: ""), image: UIImage(systemName: "gearshape")!, size: .medium)
        case .inLocalization:
            return .filled(title: NSLocalizedString("HomeViewController_ActionButton_InLocalization", comment: ""), image: UIImage(systemName: "location")!, size: .medium)
        case .readyToUnlock:
            return .filled(title: NSLocalizedString("HomeViewController_ActionButton_ReadyToUnlock", comment: ""), image: UIImage(systemName: "arrow.left.arrow.right")!, size: .medium)
        }
    }
}



