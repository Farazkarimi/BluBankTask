//
//  DetailModule.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum DetailModule {
    struct Configuration {

        fileprivate let transferDestination: TransferDestinationViewModel
        fileprivate let repository: HomeRepositoryProtocol

        init(transferDestination: TransferDestinationViewModel,
             repository: HomeRepositoryProtocol) {
            self.transferDestination = transferDestination
            self.repository = repository
        }
    }

    typealias SceneView = DetailViewController

    static func build(with configuration: Configuration) -> SceneView {
        let viewModel: DetailViewModelProtocol = DetailViewModel(transferDestination: configuration.transferDestination,
                                                                 repository: configuration.repository)
        let viewController = SceneView(viewModel: viewModel)
        return viewController
    }
}
