//
//  HomeRepository.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Combine

protocol HomeRepositoryProtocol {
    func getTransferList(page: Int) async throws ->[TransferDestinationViewModel]
    func getFavoriteList() -> [TransferDestinationViewModel]
    func getFavorite(by id: String) -> TransferDestinationViewModel?
    @discardableResult
    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool
    func isFavorite(transferDestination: TransferDestinationViewModel) -> Bool
    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {get}
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

    func getFavorite(by id: String) -> TransferDestinationViewModel? {
        return homeDAO.getFavorite(by: id)
    }

    @discardableResult
    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        return homeDAO.toggleFavorite(transferDestination: transferDestination)
    }


    func isFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        return homeDAO.isFavorite(transferDestination: transferDestination)
    }

    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {
        return homeDAO.changePublisher
    }
}
