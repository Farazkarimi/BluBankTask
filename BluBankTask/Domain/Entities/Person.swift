//
//  Person.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

struct Person: Codable, Hashable {
    let fullName: String
    let email: String?
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email = "email"
        case avatar = "avatar"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try values.decode(String.self, forKey: .fullName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        avatar = try values.decode(String.self, forKey: .avatar)
    }
}
