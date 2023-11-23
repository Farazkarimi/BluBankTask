//
//  TransferDestination.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct TransferDestination: Codable {
    var id: String { String(describing: self) }
    var fullName: String
    var email: String?
    var avatar: String
    var cardNumber: String
    var numberOfTransfers: Int

    enum CodingKeys: String, CodingKey {
        case person
        case card
        case last_transfer
        case more_info

        case full_name
        case email
        case avatar
        case card_number
        case number_of_transfers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let personContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .person)
        fullName = try personContainer.decode(String.self, forKey: .full_name)
        email = try personContainer.decodeIfPresent(String.self, forKey: .email)
        avatar = try personContainer.decode(String.self, forKey: .avatar)

        let cardContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .card)
        cardNumber = try cardContainer.decode(String.self, forKey: .card_number)

        let moreInfoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .more_info)
        numberOfTransfers = try moreInfoContainer.decode(Int.self, forKey: .number_of_transfers)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var personContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .person)
        try personContainer.encode(fullName, forKey: .full_name)
        try personContainer.encodeIfPresent(email, forKey: .email)
        try personContainer.encode(avatar, forKey: .avatar)

        var cardContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .card)
        try cardContainer.encode(cardNumber, forKey: .card_number)

        var moreInfoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .more_info)
        try moreInfoContainer.encode(numberOfTransfers, forKey: .number_of_transfers)
    }
}

