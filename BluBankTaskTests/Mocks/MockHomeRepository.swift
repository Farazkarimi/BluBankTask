//
//  MockHomeRepository.swift
//  BluBankTaskTests
//
//  Created by Faraz on 11/26/23.
//

import Foundation
import Combine

class MockHomeRepository: HomeRepositoryProtocol {
    private var transferList: [TransferDestinationViewModel] = []
    private var favoriteList: [TransferDestinationViewModel] = []
    private var changeSubject = PassthroughSubject<(T: Codable, ObjectChangeState), Never>()

    func setTransferList(_ transferList: [TransferDestinationViewModel]) {
        self.transferList = transferList
    }

    func setFavoriteList(_ favoriteList: [TransferDestinationViewModel]) {
        self.favoriteList = favoriteList
    }

    func setChangeSubject(_ subject: PassthroughSubject<(T: Codable, ObjectChangeState), Never>) {
        self.changeSubject = subject
    }

    func getTransferList(page: Int) async throws -> [TransferDestinationViewModel] {
        return transferList
    }

    func getFavoriteList() -> [TransferDestinationViewModel] {
        return favoriteList
    }

    func getFavorite(by id: String) -> TransferDestinationViewModel? {
        return favoriteList.first(where: { $0.id == id })
    }

    @discardableResult
    func toggleFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        let isFavorite = !favoriteList.contains(where: { $0.id == transferDestination.id })
        if isFavorite {
            favoriteList.append(transferDestination)
            changeSubject.send((transferDestination, .added))
        } else {
            favoriteList.removeAll(where: { $0.id == transferDestination.id })
            changeSubject.send((transferDestination, .removed))
        }
        return isFavorite
    }

    func isFavorite(transferDestination: TransferDestinationViewModel) -> Bool {
        return favoriteList.contains(where: { $0.id == transferDestination.id })
    }

    var changePublisher: AnyPublisher<(T: Codable, ObjectChangeState), Never> {
        return changeSubject.eraseToAnyPublisher()
    }
}
