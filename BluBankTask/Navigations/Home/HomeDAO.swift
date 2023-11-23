//
//  HomeDAO.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

protocol HomeDAOProtocol {
    func isFavorite(key: String) -> Bool
    func getFavoriteList() -> [TransferDestinationViewModel]
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
}
