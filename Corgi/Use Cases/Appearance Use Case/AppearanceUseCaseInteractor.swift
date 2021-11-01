//
//  AppearanceUseCaseInteractor.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

class AppearanceUseCaseInteractor {
    weak var outputBoundary: AppearanceUseCaseOutputBoundary? = nil
    
    private let dataAccessInterface: AppearanceAccessInterface
    
    init(dataAccessInterface: AppearanceAccessInterface) {
        self.dataAccessInterface = dataAccessInterface
    }
}

extension AppearanceUseCaseInteractor: AppearanceUseCaseInputBoundary {
    func save(appearance: Int) {
        let _ = self.dataAccessInterface.update(appearance: appearance)
    }
    
    func read() {
        let appearance = self.dataAccessInterface.read()
        self.outputBoundary?.send(appearance: appearance)
    }
}
