//
//  HomeViewModelProtocol.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var state: CurrentValueSubject<HomeViewModelState, Never> { get }
    func action(_ handler: HomeViewModelAction)
}

struct HomeViewModelState {

    init() {
    }

    func update() -> HomeViewModelState {
        return self
    }
}

enum HomeViewModelAction {

}


