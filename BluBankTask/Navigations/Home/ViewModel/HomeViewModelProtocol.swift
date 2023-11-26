//
//  HomeViewModelProtocol.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var state: AnyPublisher<HomeViewModelState, Never> { get }
    func action(_ handler: HomeViewModelAction)
}

enum EventMediaCommentRoute: Equatable {
    case showDetail(TransferDestinationViewModel)
}

enum TransferDestinationObject: Hashable {
    case transferDestinationList(_ transferList: [TransferDestinationViewModel],
                                 _ favoriteList: [TransferDestinationViewModel],
                                 hasMore: Bool)
    case empty
}

struct HomeViewModelState {

    let route: EventMediaCommentRoute?
    let transferDestinationList: Loadable<TransferDestinationObject>

    var dataSource: [TransferDestinationViewModel] {
        if case let .loaded(transfer) = transferDestinationList,
           case let .transferDestinationList(transferList, _, _) = transfer {
            return transferList
        } else {
            return []
        }
    }

    var favoriteDataSource: [TransferDestinationViewModel] {
        if case let .loaded(transfer) = transferDestinationList,
           case let .transferDestinationList(_, favoriteList, _) = transfer {
            return favoriteList
        } else {
            return []
        }
    }

    func update(route: EventMediaCommentRoute? = nil,
                transferDestinationList: Loadable<TransferDestinationObject>? = nil) -> HomeViewModelState {
        HomeViewModelState(route: route,
                           transferDestinationList: transferDestinationList ?? self.transferDestinationList)
    }
}

enum HomeViewModelAction {
    case getTransferList(_ refresh: Bool = false)
    case toggleFavorite(IndexPath)
    case loadMoreIfNeeded(IndexPath)
    case showDetail(IndexPath, HomeViewModel.SelectedSection)
}
