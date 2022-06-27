//
//  LoginPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation
import UIKit
import LocalAuthentication

protocol AuthenticationView: AnyObject, ErrorAlert {
    var presenter: AuthenticationPresenter! { get set }
    
    func setLoginFieldsHiddenStatus(isHidden: Bool, animated: Bool)
    func showLoginSpinner()
    func hideLoginSpinner()
    
    var passwordValue: String? { get set }
    var accountNameValue: String? { get set }
    var rememberMeValue: Bool { get set }
}

protocol AuthenticationPresenterDelegate: AnyObject {
    func didCompleteAuthentication(with clientConfiguration: ClientConfiguration, in presenter: AuthenticationPresenter)
    func didTapEditConfiguration(in presenter: AuthenticationPresenter)

}

class AuthenticationPresenter {
    weak var view: AuthenticationView?
    var delegate: AuthenticationPresenterDelegate?
    
    private let authenticationService: AuthenticationService
        
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func viewDidLoad() {
        if authenticationService.rememberMe {
            view?.setLoginFieldsHiddenStatus(isHidden: true, animated: false)
            startRememberMeAuthentication()
        } else {
            view?.setLoginFieldsHiddenStatus(isHidden: false, animated: false)
        }
        
        view?.rememberMeValue = UserDefaultConfig.rememberMe
    }
    
    func didChangeRememberMeValue(newValue: Bool) {
        if newValue {
            checkDeviceOwnerAuthenticationWithBiometrics { result in
                if !result {
                    self.view?.rememberMeValue = false
                }
            }
        }
    }
    
    func didTapEditConfiguration() {
        delegate?.didTapEditConfiguration(in: self)
    }
        
    func didTapLogin() {
        guard let password = view?.passwordValue,
              let accountName = view?.accountNameValue,
              let rememberMe = view?.rememberMeValue else { return }
            
        self.view?.showLoginSpinner()
        authenticationService.login(accountName: accountName, password: password, rememberMe: rememberMe) { [weak self] result in
            self?.handleAuthentication(result: result)
        }
    }
    
    private func startRememberMeAuthentication() {
        self.checkDeviceOwnerAuthenticationWithBiometrics { [weak self] isDeviceOwner in
            guard let self = self else { return }
            if isDeviceOwner {
                self.authenticationService.loginWithRememberMe { [weak self] result in
                    guard let self = self else { return }
                    self.handleAuthentication(result: result)
                }
            } else {
                DispatchQueue.performUIOperation {
                    self.view?.setLoginFieldsHiddenStatus(isHidden: false, animated: true)
                }
            }
        }
    }
    
    private func handleAuthentication(result: Result<ClientConfiguration, AuthenticationError>) {
        switch result {
        case .success(let clientConfiguration):
            delegate?.didCompleteAuthentication(with: clientConfiguration, in: self)
        case .failure(let error):
            DispatchQueue.performUIOperation {
                switch error {
                case .invalidLoginCredentials:
                    self.view?.showErrorAlert(with: "The login credentials were invalid.", title: "Wrong credentials")
                case .noNetwork:
                    self.view?.showErrorAlert(with: "No network. Please check your internet connection", title: "No internet")
                case .serverError:
                    self.view?.showErrorAlert(with: "There was an internal server error. Sorry!", title: "Oops")
                case .internalError:
                    self.view?.showErrorAlert(with: "There was an internal server error. Sorry!", title: "Oops")
                }
                self.view?.setLoginFieldsHiddenStatus(isHidden: false, animated: true)
                self.view?.hideLoginSpinner()
            }
        }
    }
    
    private func checkDeviceOwnerAuthenticationWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Identify yourself"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
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
