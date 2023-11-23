//
//  HomeModule.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum HomeViewModule {
    struct Configuration {
        fileprivate let repository: HomeRepositoryProtocol
        init(repository: HomeRepositoryProtocol) {
            self.repository = repository
        }
    }

    typealias SceneView = HomeViewController

    static func build(with configuration: Configuration) -> SceneView {
        var router: HomeRouting = HomeRouter(configuration: configuration)
        let viewModel: HomeViewModelProtocol = HomeViewModel(repository: configuration.repository)
        let viewController = SceneView(viewModel: viewModel, router: router)
        router.viewController = viewController
        return viewController
    }
}
