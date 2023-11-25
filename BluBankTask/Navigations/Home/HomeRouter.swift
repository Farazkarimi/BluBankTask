//
//  HomeRouter.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

protocol HomeRouting: Router {
    func showDetail(transferDestination: TransferDestinationViewModel)
}

final class HomeRouter: HomeRouting {

    // MARK: Properties
    weak var viewController: UIViewController?
    let configuration: HomeViewModule.Configuration

    init(configuration: HomeViewModule.Configuration) {
        self.configuration = configuration
    }

    func showDetail(transferDestination: TransferDestinationViewModel) {
        let vc = DetailModule.build(with: DetailModule.Configuration(transferDestination: transferDestination, 
                                                                     repository: configuration.repository))
        vc.modalPresentationStyle = .pageSheet
        viewController?.present(vc, animated: true)
    }
}
