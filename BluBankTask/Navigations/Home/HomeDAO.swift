//
//  HomeDAO.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine

protocol HomeDAOProtocol {
    func isFavorite(key: String) -> Bool
    func getFavoriteList() -> [TransferDestinationViewModel]
    func getFavorite(by id: String) -> TransferDestinationViewModel?
    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool
    func isFavorite(transferDestination: TransferDestinationViewModel) -> Bool
    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {get}
    
}

final class HomeDAO: HomeDAOProtocol {

    private let databaseManager: DatabaseManagerProtocol

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }

    func isFavorite(key: String) -> Bool {
        let favoriteModel: TransferDestinationViewModel? = databaseManager.load(forKey: key)
        return favoriteModel != nil
    }

    func getFavoriteList() -> [TransferDestinationViewModel] {
        return databaseManager.loadAll(type: TransferDestinationViewModel.self)
    }

    func getFavorite(by id: String) -> TransferDestinationViewModel? {
        return databaseManager.load(forKey: id)
    }

    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        if isFavorite(key: transferDestination.id) {
            databaseManager.remove(forKey: transferDestination.id, Type: TransferDestinationViewModel.self)
            return false
        } else {
            var object = transferDestination
            object.isFavorite = true
            databaseManager.save(object: object, forKey: transferDestination.id)
            return true
        }
    }

    func isFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        return getFavoriteList().contains(transferDestination)
    }

    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {
        return databaseManager.changePublisher
    }
}
