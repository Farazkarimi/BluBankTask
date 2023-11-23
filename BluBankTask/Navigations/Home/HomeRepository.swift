//
//  HomeRepository.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

protocol HomeRepositoryProtocol {
    func getTransferList(page: Int) async throws ->[TransferDestinationViewModel]
    func getFavoriteList() -> [TransferDestinationViewModel]
}

final class HomeRepository: HomeRepositoryProtocol {

    let networkManager: NetworkManagerProtocol
    let homeDAO: HomeDAOProtocol


    init(networkManager: NetworkManagerProtocol, homeDAO: HomeDAOProtocol) {
        self.networkManager = networkManager
        self.homeDAO = homeDAO
    }

    func getTransferList(page: Int) async throws ->[TransferDestinationViewModel] {
        return try await networkManager
            .sendArrayRequest(TransferEndpoints.getTransferList(page), responseType: TransferDestination.self)
            .map({  model in
                return TransferDestinationViewModel(transferDestination: model,
                                                    isFavorite: homeDAO.isFavorite(key: model.id))
            })
    }

    func getFavoriteList() -> [TransferDestinationViewModel] {
        return homeDAO.getFavoriteList()
    }
}
