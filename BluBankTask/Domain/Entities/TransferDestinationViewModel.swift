//
//  TransferDestinationViewModel.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct TransferDestinationViewModel: Hashable, Codable {
    var id: String
    let fullName: String
    let cardNumber: String
    let avatar: String
    var isFavorite: Bool

    init(transferDestination: TransferDestination, isFavorite: Bool) {
        self.id = transferDestination.id
        self.fullName = transferDestination.person.fullName
        self.cardNumber = transferDestination.card.cardNumber
        self.avatar = transferDestination.person.avatar
        self.isFavorite = isFavorite
    }
}

