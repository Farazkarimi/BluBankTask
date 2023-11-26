//
//  HomeViewModel.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine
import Foundation

final class HomeViewModel: HomeViewModelProtocol {

    private var stateSubject : CurrentValueSubject<HomeViewModelState, Never>
    var state: AnyPublisher<HomeViewModelState, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    private var repository: HomeRepositoryProtocol
    private var cancellables: Set<AnyCancellable> =  .init()
    private var fetchTask: Task<(), Never>?
    private var page: Int = 0
    private var numberOfPages = 5


    enum SelectedSection {
        case all
        case favorites
    }

    enum FetchError: Error {
        case cancelled
    }

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        stateSubject = .init(.init(route: nil, transferDestinationList: .initial))
        bind()
    }

    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case let .getTransferList(refresh):
            getTransferList(refresh: refresh)
        case let .toggleFavorite(indexPath):
            toggleFavorite(indexPath: indexPath)
        case let .loadMoreIfNeeded(indexPath):
            loadMoreIfNeeded(indexPath: indexPath)
        case let .showDetail(indexPath, section):
            showDetail(at: indexPath, section: section)
        }
    }

    private func update(route: EventMediaCommentRoute? = nil,
                        transferDestinationList: Loadable<TransferDestinationObject>? = nil) {
        stateSubject.value = stateSubject.value.update(route: route,
                                         transferDestinationList: transferDestinationList)
    }

    private func bind() {
        repository
            .changePublisher
            .compactMap({ (T: Codable, ObjectChangeState) in
                return (T as? TransferDestinationViewModel, ObjectChangeState)
            })
            .sink { [weak self] (transferModel, changeState) in
                guard let self, let transferModel else { return }
                let isFavorite: Bool
                switch changeState {
                case .added:
                    isFavorite = true
                case .removed:
                    isFavorite = false
                }
                self.updateDatasource(transferDestination: transferModel, isFavorite: isFavorite)
            }.store(in: &cancellables)
    }

    private func getTransferList(refresh: Bool) {
        guard (page != numberOfPages || refresh) else { return }
        let datasource = stateSubject.value.dataSource
        self.update(transferDestinationList: .loading)
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
                    self.update(transferDestinationList: .error(FetchError.cancelled))
                    return
                }
                let transferList = try await repository.getTransferList(page: page)
                guard !fetchTask.isCancelled else {
                    self.update(transferDestinationList: .error(FetchError.cancelled))
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
                self.update(transferDestinationList: .error(error))
            }
        }
    }

    private func loadMoreIfNeeded(indexPath: IndexPath) {
        guard indexPath.item + 1 == stateSubject.value.dataSource.count  else { return }
        getTransferList(refresh: false)
    }

    private func toggleFavorite(indexPath: IndexPath) {
        let model = stateSubject.value.dataSource[indexPath.row]
        repository.toggleFavorite(transferDestination: model)
    }

    private func updateDatasource(transferDestination: TransferDestinationViewModel, isFavorite: Bool) {
        var datasource = stateSubject.value.dataSource
        if let index = datasource.firstIndex(where: {$0.id == transferDestination.id}) {
            datasource[index].isFavorite = isFavorite
        }
        let favoriteList = repository.getFavoriteList()
        self.update(transferDestinationList: .loaded(.transferDestinationList(datasource,
                                                                              favoriteList,
                                                                              hasMore: page != numberOfPages)))
    }

    private func showDetail(at indexPath: IndexPath, section: HomeViewModel.SelectedSection) {
        let model: TransferDestinationViewModel
        switch section {
        case .favorites:
            model = stateSubject.value.favoriteDataSource[indexPath.row]
        case .all:
            model = stateSubject.value.dataSource[indexPath.row]
        }
        update(route: .showDetail(model))
    }
}
