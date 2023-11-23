//
//  HomeViewCotroller.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine
import Foundation

final class DetailViewModel: DetailViewModelProtocol {

    var state: CurrentValueSubject<DetailViewModelState, Never>

    private var transferDestiation: TransferDestinationViewModel

    init(transferDestiation: TransferDestinationViewModel) {
        self.transferDestiation = transferDestiation
        state = .init(.init(transferDestiation: transferDestiation))
    }

    func action(_ handler: DetailViewModelAction) {
        switch handler {
        case .fetchTransferModel:
            update(transferDestiation: transferDestiation)
        }
    }

    private func update(transferDestiation: TransferDestinationViewModel? = nil) {
        state.value = state.value.update(transferDestiation: transferDestiation)
    }
}
