//
//  HomeDAO.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

protocol HomeDAOProtocol {
    func isFavorite(key: String) -> Bool
    func getFavoriteList() -> [TransferDestinationViewModel]
    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool
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

    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        if isFavorite(key: transferDestination.id) {
            databaseManager.remove(forKey: transferDestination.id)
            return false
        } else {
            var object = transferDestination
            object.isFavorite = true
            databaseManager.save(object: object, forKey: transferDestination.id)
            return true
        }
    }
}
