//
//  DetailModule.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum DetailModule {
    struct Configuration {

        fileprivate let transferDestiation: TransferDestinationViewModel
        fileprivate let repository: HomeRepositoryProtocol

        init(transferDestiation: TransferDestinationViewModel,
             repository: HomeRepositoryProtocol) {
            self.transferDestiation = transferDestiation
            self.repository = repository
        }
    }

    typealias SceneView = DetailViewController

    static func build(with configuration: Configuration) -> SceneView {
        let viewModel: DetailViewModelProtocol = DetailViewModel(transferDestiation: configuration.transferDestiation, 
                                                                 repository: configuration.repository)
        let viewController = SceneView(viewModel: viewModel)
        return viewController
    }
}
