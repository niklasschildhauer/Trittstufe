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
    
    func setLoginFieldsHiddenStatus(isHidden: Bool)
    func showError(message: String)
    func hideError()
    
    var passwordValue: String? { get set }
    var accountNameValue: String? { get set }
    var rememberMeValue: Bool { get set }
}

protocol AuthenticationPresenterDelegate: AnyObject {
    func didCompletecAuthentication(in presenter: AuthenticationPresenter)
}

class AuthenticationPresenter {
    weak var view: AuthenticationView?
    weak var delegate: AuthenticationPresenterDelegate?
    
    private let userService: UserService
        
    init(userService: UserService) {
        self.userService = userService
    }
    
    func viewDidLoad() {
        if userService.rememberMe {
            view?.setLoginFieldsHiddenStatus(isHidden: true)
            startRememberMeAuthentication()
        } else {
            view?.setLoginFieldsHiddenStatus(isHidden: false)
        }
    }
        
    func didTapLogin() {
        guard let password = view?.passwordValue,
              let accountName = view?.accountNameValue,
              let rememberMe = view?.rememberMeValue else { return }
            
        userService.login(accountName: accountName, password: password, rememberMe: rememberMe) { [weak self] result in
            self?.handleAuthentication(result: result)
        }
    }
    
    private func startRememberMeAuthentication() {
        self.checkDeviceOwnerAuthenticationWithBiometrics { [weak self] isDeviceOwner in
            if isDeviceOwner {
                self?.userService.loginWithRememberMe { [weak self] result in
                    self?.handleAuthentication(result: result)
                }
            } else {
                DispatchQueue.performUIOperation {
                    self?.view?.setLoginFieldsHiddenStatus(isHidden: false)
                }
            }
        }
    }
    
    private func handleAuthentication(result: Result<String, UserService.AuthenticationError>) {
        switch result {
        case .success(_):
            delegate?.didCompletecAuthentication(in: self)
        case .failure(let error):
            DispatchQueue.performUIOperation {
                switch error {
                case .invalidLoginCredentials:
                    self.view?.showError(message: "The login credentials were invalid.")
                case .noNetwork:
                    self.view?.showError(message: "No network. Please check your internet connection")
                case .serverError:
                    self.view?.showError(message: "There was an internal server error. Sorry!")
                }
                self.view?.setLoginFieldsHiddenStatus(isHidden: false)
            }
        }
    }
    
    private func checkDeviceOwnerAuthenticationWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
        } else {
            completion(false)
        }
    }
}
