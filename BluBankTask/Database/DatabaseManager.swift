//
//  DatabaseManager.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation
import Combine

protocol DatabaseManagerProtocol {
    func save<T: Codable>(object: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
    func loadAll<T: Codable>(type: T.Type) -> [T]
    func remove<T: Codable>(forKey key: String, Type: T.Type)
    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> { get }
}

enum ObjectChangeState {
    case added
    case removed
}

final class Database: DatabaseManagerProtocol {
    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {
        changePublisherSubject.eraseToAnyPublisher()
    }

    private let changePublisherSubject: PassthroughSubject<(T: Codable, ObjectChangeState), Never> = .init()
    private let userDefaults: UserDefaultsProtocol
    private let keyPrefix: String

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard, keyPrefix: String = "com.bluTask.database.") {
        self.userDefaults = userDefaults
        self.keyPrefix = keyPrefix
    }

    func save<T: Codable>(object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: keyPrefix + key)
            changePublisherSubject.send((object, .added))
        } catch {
            print("Error saving object: \(error)")
        }
    }

    func remove<T: Codable>(forKey key: String, Type: T.Type) {
        guard let object: T? = load(forKey: key) else {
            return
        }
        userDefaults.removeObject(forKey: keyPrefix + key)
        changePublisherSubject.send((object, .removed))
    }

    func load<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: keyPrefix + key) else {
            return nil
        }

        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error loading object: \(error)")
            return nil
        }
    }

    func loadAll<T: Codable>(type: T.Type) -> [T] {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.hasPrefix(keyPrefix) }
        let objects: [T] = keys.compactMap { key in
            guard let data = userDefaults.data(forKey: key) else {
                return nil
            }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return object
            } catch {
                print("Error loading object: \(error)")
                return nil
            }
        }

        return objects
    }
}
