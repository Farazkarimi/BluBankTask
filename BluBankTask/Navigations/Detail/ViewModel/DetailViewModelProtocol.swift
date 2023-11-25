//
//  DetailViewModelProtocol.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var state: AnyPublisher<DetailViewModelState, Never> { get }
    func action(_ handler: DetailViewModelAction)
}

struct DetailViewModelState {

    let transferDestination: TransferDestinationViewModel

    func update(transferDestination: TransferDestinationViewModel?) -> DetailViewModelState {
        return .init(transferDestination: transferDestination ?? self.transferDestination)
    }
}

enum DetailViewModelAction {
    case fetchTransferModel
    case toggleFavorite
}
