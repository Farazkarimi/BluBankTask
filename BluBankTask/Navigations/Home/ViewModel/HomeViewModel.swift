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

    private var repository: HomeRepositoryProtocol
    private var cancellables: Set<AnyCancellable> =  .init()
    private var page: Int = 0
    private var numberOfPages = 5

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        state = .init(.init(transferDestinationList: .notRequested))
    }

    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case let .getTransferList(refresh):
            getTransferList(refresh: refresh)
        case let .toggleFavorite(tansferDestination):
            break
        case let .loadMoreIfNeeded(indexPath):
            loadMoreIfNeeded(indexPath: indexPath)
        }
    }

    private func update(transferDestinationList: Loadable<TransferDestinationObject>? = nil,
                        transferDestinationFavoriteList: Loadable<TransferDestinationObject>? = nil) {
        state.value = state.value.update(transferDestinationList: transferDestinationList)
    }

    private func getTransferList(refresh: Bool) {
        guard (page != numberOfPages || refresh) else { return }
        let datasource = state.value.dataSource
        self.update(transferDestinationList: .isLoading())
        Task { [weak self, datasource] in
            guard let self else { return }
            do {
                if refresh {
                    self.page = 1
                } else {
                    self.page = self.page + 1
                }
                let allTransferList: [TransferDestinationViewModel]

                let transferList = try await repository.getTransferList(page: page)
                if refresh {
                    allTransferList = transferList
                } else {
                    allTransferList = datasource + transferList
                }
                let favoriteList = repository.getFavoriteList()
                self.update(transferDestinationList: .loaded(.transferDestinationList(allTransferList,
                                                                                      favoriteList,
                                                                                      hasMore: page != numberOfPages)))
            } catch {
                self.update(transferDestinationList: .failed(error))
            }
        }
    }

    private func loadMoreIfNeeded(indexPath: IndexPath) {
        guard indexPath.item + 1 == state.value.dataSource.count  else { return }
        getTransferList(refresh: false)
    }
}
