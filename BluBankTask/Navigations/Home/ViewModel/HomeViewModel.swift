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
    private var fetchTask: Task<(), Never>?
    private var page: Int = 0
    private var numberOfPages = 5

    enum FetchError: Error {
        case cancelled
    }

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        state = .init(.init(route: nil, transferDestinationList: .notRequested))
    }

    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case let .getTransferList(refresh):
            getTransferList(refresh: refresh)
        case let .toggleFavorite(transferDestination):
            toggleFavorite(transferDestination: transferDestination)
        case let .loadMoreIfNeeded(indexPath):
            loadMoreIfNeeded(indexPath: indexPath)
        case let .showDetail(indexPath, section):
            showDetail(at: indexPath, section: section)
        }
    }

    private func update(route: EventMediaCommentRoute? = nil,
                        transferDestinationList: Loadable<TransferDestinationObject>? = nil) {
        state.value = state.value.update(route: route,
                                         transferDestinationList: transferDestinationList)
    }

    private func getTransferList(refresh: Bool) {
        guard (page != numberOfPages || refresh) else { return }
        let datasource = state.value.dataSource
        self.update(transferDestinationList: .isLoading())
        fetchTask?.cancel()
        fetchTask = Task { [weak self, datasource] in
            guard let self else { return }
            do {
                if refresh {
                    self.page = 1
                } else {
                    self.page = self.page + 1
                }
                let allTransferList: [TransferDestinationViewModel]
                guard let fetchTask, !fetchTask.isCancelled else {
                    self.update(transferDestinationList: .failed(FetchError.cancelled))
                    return
                }
                let transferList = try await repository.getTransferList(page: page)
                guard !fetchTask.isCancelled else {
                    self.update(transferDestinationList: .failed(FetchError.cancelled))
                    return
                }
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

    private func toggleFavorite(transferDestination: TransferDestinationViewModel) {
        var datasource = state.value.dataSource
        let isFavorite = repository.toggleFavorite(transferDestination: transferDestination)
        if let index = datasource.firstIndex(where: {$0.id == transferDestination.id}) {
            datasource[index].isFavorite = isFavorite
        }
        let favoriteList = repository.getFavoriteList()
        self.update(transferDestinationList: .loaded(.transferDestinationList(datasource,
                                                                              favoriteList,
                                                                              hasMore: page != numberOfPages)))
    }

    private func showDetail(at indexPath: IndexPath, section: HomeViewController.Section) {
        let model: TransferDestinationViewModel
        switch section {
        case .favorites:
            model = state.value.favoriteDataSource[indexPath.row]
        case .all:
            model = state.value.dataSource[indexPath.row]
        }
        update(route: .showDetail(model))
    }
}
