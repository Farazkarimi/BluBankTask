//
//  TransferDestinationViewModel+Stubbing.swift
//  BluBankTaskTests
//
//  Created by Faraz on 11/26/23.
//

import Foundation
@testable import BluBankTask

extension TransferDestinationViewModel {
    static func stub(transferDestination: TransferDestination? = nil, isFavorite: Bool? = nil) -> Self {
        .init(transferDestination: transferDestination ?? TransferDestination.stub(),
              isFavorite: isFavorite ?? Bool.random())
    }
}

extension TransferDestination {
    static func stub() -> Self {
        var json: Data {
            return """
            {
                "person": {
                    "full_name": "\(UUID().uuidString)",
                    "email": "aa@bb.com",
                    "avatar": "https://www.dropbox.com/s/64y9lcnca22p1jx/avatar1.png?dl=1"
                },
                "card": {
                    "card_number": "\(Int.random(in: 99999...999999))"
                },
                "more_info": {
                    "number_of_transfers": \(Int.random(in: 1...100))
                }
            }
            """.data(using: .utf8)!
        }
        return try! JSONDecoder().decode(TransferDestination.self, from: json)
    }
}
