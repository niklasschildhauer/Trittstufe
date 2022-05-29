//
//  Color.swift
//  cleanmywallet
//
//  Created by Niklas Schildhauer on 16.03.22.
//

import UIKit

struct Color {
    
    // MARK: backround status color
    static var statusBackround20: UIColor { UIColor(named: "statusBackground-20", in: Bundle.main, compatibleWith: nil)! }
    static var statusBackround40: UIColor { UIColor(named: "statusBackground-40", in: Bundle.main, compatibleWith: nil)! }
    static var statusBackround60: UIColor { UIColor(named: "statusBackground-60", in: Bundle.main, compatibleWith: nil)! }
    static var statusBackround80: UIColor { UIColor(named: "statusBackground-80", in: Bundle.main, compatibleWith: nil)! }

    
    static var plainWhite: UIColor { UIColor(named: "whiteNoDarkMode", in: Bundle.main, compatibleWith: nil)! }
    static var plainBlack: UIColor { UIColor(named: "blackNoDarkMode", in: Bundle.main, compatibleWith: nil)! }

    static var statusRed: UIColor { UIColor(named: "statusRed", in: Bundle.main, compatibleWith: nil)! }
    static var statusGreen: UIColor { UIColor(named: "statusGreen", in: Bundle.main, compatibleWith: nil)! }
    static var statusYellow: UIColor { UIColor(named: "statusYellow", in: Bundle.main, compatibleWith: nil)!}
    
    static var black: UIColor { UIColor(named: "black", in: Bundle.main, compatibleWith: nil)! }
    static var white: UIColor { UIColor(named: "white", in: Bundle.main, compatibleWith: nil)! }
}
