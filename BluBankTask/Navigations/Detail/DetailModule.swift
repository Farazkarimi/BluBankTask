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

        init(transferDestiation: TransferDestinationViewModel) {
            self.transferDestiation = transferDestiation
        }
    }

    typealias SceneView = DetailViewController

    static func build(with configuration: Configuration) -> SceneView {
        let viewModel: DetailViewModelProtocol = DetailViewModel(transferDestiation: configuration.transferDestiation)
        let viewController = SceneView(viewModel: viewModel)
        return viewController
    }
}
