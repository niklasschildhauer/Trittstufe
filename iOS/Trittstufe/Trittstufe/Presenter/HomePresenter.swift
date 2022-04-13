//
//  HomePresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 02.04.22.
//

import Foundation
import UIKit

protocol HomeView: AnyObject {
    var presenter: HomePresenter! { get set }
}

protocol HomePresenterDelegate: AnyObject {
    func didTapLogout(in presenter: HomePresenter)
}

class HomePresenter: Presenter {
    weak var view: HomeView?
    var delegate: HomePresenterDelegate?
    
    private let stepEngineControlService: StepEngineControlService
    
    init(stepEngineControlService: StepEngineControlService) {
        self.stepEngineControlService = stepEngineControlService
    }
    
    func viewDidLoad() {
        
    }
    
    func sendTestMessage() {
        stepEngineControlService.extendStep()
    }
    
    func logout() {
        delegate?.didTapLogout(in: self)
    }
}
