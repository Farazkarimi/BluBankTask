//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Faraz on 11/23/23.
//

import XCTest
import Combine
@testable import BluBankTask

class HomeViewModelTests: XCTestCase {

    //TODO: Test its not completed and its just for demo

    enum Constant {
        static let transferList: [TransferDestinationViewModel] = [TransferDestinationViewModel.stub(isFavorite: false),
                                                                   TransferDestinationViewModel.stub(isFavorite: true),
                                                                   TransferDestinationViewModel.stub(isFavorite: true),
                                                                   TransferDestinationViewModel.stub(isFavorite: false)]
        static let favoriteList = [transferList.first!]

    }

    var viewModel: HomeViewModel!
    var mockRepository: MockHomeRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockRepository = MockHomeRepository()
        viewModel = HomeViewModel(repository: mockRepository!)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testGetTransferListSuccess() {
        let transferList: [TransferDestinationViewModel] = Constant.transferList
        mockRepository.setTransferList(transferList)

        let expectation = XCTestExpectation(description: "Get transfer list successfully")

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel] in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(list, _, _) = object {
                    return list
                } else {
                    return []
                }
            })
            .drop(while: {$0.isEmpty})
            .sink { list in
                XCTAssertEqual(list, Constant.transferList)
                expectation.fulfill()
            }.store(in: &cancellables)

        viewModel.action(.getTransferList(true))

        wait(for: [expectation], timeout: 1)
    }

    func testToggleFavorite() {
        let transferList: [TransferDestinationViewModel] = [Constant.transferList.first!]
        mockRepository.setTransferList(transferList)

        let expectation = XCTestExpectation(description: "Toggle favorite successfully")

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel]? in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(list, _, _) = object {
                    return list
                } else {
                    return nil
                }
            })
            .drop(while: {$0.isEmpty})
            .removeDuplicates(by: { lhs, rhs in
                lhs.count == rhs.count
            })
            .sink { list in
                self.viewModel.action(.toggleFavorite(IndexPath(row: 0, section: 0)))
            }.store(in: &cancellables)

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel]? in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(_, favList, _) = object,
                   !favList.isEmpty {
                    return favList
                } else {
                    return nil
                }
            })
            .sink { list in
                XCTAssertEqual(list.first!.id, Constant.transferList.first!.id)
                expectation.fulfill()
            }.store(in: &cancellables)

        viewModel.action(.getTransferList(true))

        wait(for: [expectation], timeout: 1)
    }

    func testLoadMoreIfNeeded() {
        let transferList: [TransferDestinationViewModel] = Constant.transferList
        mockRepository.setTransferList(transferList)

        let expectation = XCTestExpectation(description: "Load more if needed")

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel]? in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(list, _, _) = object {
                    return list
                } else {
                    return nil
                }
            })
            .drop(while: {$0.isEmpty})
            .removeDuplicates(by: { lhs, rhs in
                lhs.count == rhs.count
            })
            .sink { [self] list in
                viewModel.action(.loadMoreIfNeeded(IndexPath(row: list.count - 1, section: 0)))
            }.store(in: &cancellables)

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel]? in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(list, _, _) = object {
                    return list
                } else {
                    return nil
                }
            })
            .dropFirst(4)
            .sink { list in
                XCTAssertEqual(list.count, 20)
                expectation.fulfill()
            }.store(in: &cancellables)

        viewModel.action(.getTransferList(false))

        wait(for: [expectation], timeout: 1)
    }

    func testShowDetail() {
        let transferList: [TransferDestinationViewModel] = Constant.transferList
        mockRepository.setTransferList(transferList)

        let expectation = XCTestExpectation(description: "Show detail successfully")

        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.state
            .map(\.transferDestinationList)
            .compactMap({ loadable -> [TransferDestinationViewModel]? in
                if case let .loaded(object) = loadable,
                   case let .transferDestinationList(list, _, _) = object {
                    return list
                } else {
                    return nil
                }
            })
            .drop(while: {$0.isEmpty})
            .removeDuplicates(by: { lhs, rhs in
                lhs.count == rhs.count
            })
            .sink { [self] list in
                viewModel.action(.showDetail(indexPath, .all))
            }.store(in: &cancellables)

        viewModel.state
            .map(\.route)
            .sink { route in
                if case let .showDetail(model) = route {
                    XCTAssertEqual(model.id, Constant.transferList.first?.id)
                    expectation.fulfill()
                }
            }.store(in: &cancellables)

        viewModel.action(.getTransferList(false))
        wait(for: [expectation], timeout: 1)
    }
}
