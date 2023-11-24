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
    private var repository: HomeRepositoryProtocol
    private var cancellables: Set<AnyCancellable> =  .init()

    init(transferDestiation: TransferDestinationViewModel,
         repository: HomeRepositoryProtocol) {
        self.transferDestiation = transferDestiation
        self.repository = repository
        state = .init(.init(transferDestiation: transferDestiation))
    }

    func action(_ handler: DetailViewModelAction) {
        switch handler {
        case .fetchTransferModel:
            update(transferDestiation: transferDestiation)
        case .toggleFavorite:
            toggleFavorite()
        }
    }

    private func update(transferDestiation: TransferDestinationViewModel? = nil) {
        state.value = state.value.update(transferDestiation: transferDestiation)
    }

    private func toggleFavorite() {
        transferDestiation.isFavorite = repository.toggleFavorite(transferDestination: transferDestiation)
        update(transferDestiation: transferDestiation)
    }
}
