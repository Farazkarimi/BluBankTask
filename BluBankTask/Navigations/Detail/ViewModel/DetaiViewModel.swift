//
//  HomeViewCotroller.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine
import Foundation

final class DetailViewModel: DetailViewModelProtocol {

    var state: AnyPublisher<DetailViewModelState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    var stateSubject: CurrentValueSubject<DetailViewModelState, Never>

    private var transferDestination: TransferDestinationViewModel
    private var repository: HomeRepositoryProtocol
    private var cancellables: Set<AnyCancellable> =  .init()

    init(transferDestination: TransferDestinationViewModel,
         repository: HomeRepositoryProtocol) {
        self.transferDestination = transferDestination
        self.repository = repository
        stateSubject = .init(.init(transferDestination: transferDestination))
    }

    func action(_ handler: DetailViewModelAction) {
        switch handler {
        case .fetchTransferModel:
            update(transferDestination: transferDestination)
        case .toggleFavorite:
            toggleFavorite()
        }
    }

    private func update(transferDestination: TransferDestinationViewModel? = nil) {
        stateSubject.value = stateSubject.value.update(transferDestination: transferDestination)
    }

    private func toggleFavorite() {
        transferDestination.isFavorite = repository.toggleFavorite(transferDestination: transferDestination)
        update(transferDestination: transferDestination)
    }
}
