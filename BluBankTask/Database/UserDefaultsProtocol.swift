//
//  UserDefaultsProtocol.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
    func removeObject(forKey defaultName: String)
    func dictionaryRepresentation() -> [String : Any]
}

extension UserDefaults: UserDefaultsProtocol { }
