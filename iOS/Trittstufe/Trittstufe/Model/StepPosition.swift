//
//  StepPosition.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.05.22.
//

import Foundation

struct CarPosition {
    let name: String
    var stepPosition: StepPosition
}

enum StepPosition: String {
    case open
    case close
}
