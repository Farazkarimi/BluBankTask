//
//  Card.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct Card: Codable, Hashable {
    let cardNumber: String
    let cardType: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try values.decode(String.self, forKey: .cardNumber)
        cardType = try values.decodeIfPresent(String.self, forKey: .cardType)
    }
}
