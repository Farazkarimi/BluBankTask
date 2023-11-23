//
//  MoreInfo.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct MoreInfo: Codable, Hashable {
    let numberOfTransfers: Int?
    let totalTransfer: Int?

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        numberOfTransfers = try values.decodeIfPresent(Int.self, forKey: .numberOfTransfers)
        totalTransfer = try values.decodeIfPresent(Int.self, forKey: .totalTransfer)
    }
}
