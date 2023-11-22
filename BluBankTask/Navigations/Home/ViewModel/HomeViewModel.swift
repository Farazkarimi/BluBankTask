//
//  HomeViewModel.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine
import Foundation

final class HomeViewModel: HomeViewModelProtocol {

    var state: CurrentValueSubject<HomeViewModelState, Never>

    private var cancellables: Set<AnyCancellable> =  .init()

    init() {
        state = .init(.init())
    }

    func action(_ handler: HomeViewModelAction) {

    }

    private func update() {
        state.value = state.value.update()
    }
}
