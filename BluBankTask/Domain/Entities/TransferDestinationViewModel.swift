//
//  TransferDestinationViewModel.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct TransferDestinationViewModel: Hashable, Codable {
    var id: String
    var fullName: String
    var email: String?
    var avatar: String
    var cardNumber: String
    var numberOfTransfers: Int
    var isFavorite: Bool

    init(transferDestination: TransferDestination, isFavorite: Bool) {
        self.id = transferDestination.id
        self.fullName = transferDestination.fullName
        self.email = transferDestination.email
        self.avatar = transferDestination.avatar
        self.cardNumber = transferDestination.cardNumber
        self.numberOfTransfers = transferDestination.numberOfTransfers
        self.isFavorite = isFavorite
    }
}

