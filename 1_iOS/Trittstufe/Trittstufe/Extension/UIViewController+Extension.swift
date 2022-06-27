//
//  UIViewController+Extension.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 12.06.22.
//

import UIKit

/// Easy use of error alert. Implements showErrorAlert function to show an error message.
protocol ErrorAlert {
    func showErrorAlert(with message: String, title: String)
}

extension UIViewController: ErrorAlert {
    func showErrorAlert(with message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
