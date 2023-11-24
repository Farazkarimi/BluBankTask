//
//  DetailViewModelProtocol.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var state: CurrentValueSubject<DetailViewModelState, Never> { get }
    func action(_ handler: DetailViewModelAction)
}

struct DetailViewModelState {

    let transferDestiation: TransferDestinationViewModel

    func update(transferDestiation: TransferDestinationViewModel?) -> DetailViewModelState {
        return .init(transferDestiation: transferDestiation ?? self.transferDestiation)
    }
}

enum DetailViewModelAction {
    case fetchTransferModel
    case toggleFavorite
}
