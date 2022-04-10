//
//  LoginPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit
import LocalAuthentication

protocol AuthenticationView: AnyObject {
    var presenter: AuthenticationPresenter! { get set }
}

protocol AuthenticationPresenterDelegate: AnyObject {
    func didCompletecAuthentication(in presenter: AuthenticationPresenter)
}

class AuthenticationPresenter {
    weak var view: AuthenticationView?
    weak var delegate: AuthenticationPresenterDelegate?
    
    func viewDidLoad() {
        startAuthentication()
    }
    
    func didTapTestLogin() {

    }
    
    private func startAuthentication() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                guard let self = self else { return }

                DispatchQueue.performUIOperation {
                    if success {
                        self.delegate?.didCompletecAuthentication(in: self)
                    } else {
                        print(authenticationError!.localizedDescription)
                    }
                }
            }
        } else {
            print("No biometry")
        }
    }
}
