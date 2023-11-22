//
//  HomeModule.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum HomeViewModule {
    struct Configuration {

        init() {}
    }

    typealias SceneView = HomeViewController

    static func build(with configuration: Configuration) -> SceneView {
        let viewModel: HomeViewModelProtocol = HomeViewModel()
        let viewController = SceneView(viewModel: viewModel)
        return viewController
    }
}
