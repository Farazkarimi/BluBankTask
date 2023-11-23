//
//  TransferDestination.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct TransferDestination: Codable, Hashable, Identifiable {

    var id: String { String(describing: self) }
    let person: Person
    let card: Card
    let lastTransfer: String?
    let note: String?
    let moreInfo: MoreInfo?

    enum CodingKeys: String, CodingKey {
        case person = "person"
        case card = "card"
        case lastTransfer = "last_transfer"
        case note = "note"
        case moreInfo = "more_info"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        person = try values.decode(Person.self, forKey: .person)
        card = try values.decode(Card.self, forKey: .card)
        lastTransfer = try values.decodeIfPresent(String.self, forKey: .lastTransfer)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        moreInfo = try values.decodeIfPresent(MoreInfo.self, forKey: .moreInfo)
    }
}
