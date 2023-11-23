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

enum TransferDestinationObject: Hashable {
    case transferDestinationList(_ transferList: [TransferDestinationViewModel],
                                 _ favoriteList: [TransferDestinationViewModel],
                                 hasMore: Bool)
    case empty
}

struct HomeViewModelState {

    let transferDestinationList: Loadable<TransferDestinationObject>

    var dataSource: [TransferDestinationViewModel] {
        if case let .loaded(transfer) = transferDestinationList,
           case let .transferDestinationList(transferList, _, _) = transfer {
            return transferList
        } else {
            return []
        }
    }

    init(transferDestinationList: Loadable<TransferDestinationObject>) {
        self.transferDestinationList = transferDestinationList
    }

    func update(transferDestinationList: Loadable<TransferDestinationObject>? = nil) -> HomeViewModelState {
        HomeViewModelState(transferDestinationList: transferDestinationList ?? self.transferDestinationList)
    }
}

enum HomeViewModelAction {
    case getTransferList(_ refresh: Bool = false)
    case toggleFavorite(_ for: TransferDestinationViewModel)
    case loadMoreIfNeeded(IndexPath)
}
