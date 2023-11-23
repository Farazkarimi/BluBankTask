//
//  HomeRouter.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

protocol HomeRouting: Router {
    func showDetail(transferDestiation: TransferDestinationViewModel)
}

final class HomeRouter: HomeRouting {

    // MARK: Properties
    weak var viewController: UIViewController?
    let configuration: HomeViewModule.Configuration

    init(configuration: HomeViewModule.Configuration) {
        self.configuration = configuration
    }

    func showDetail(transferDestiation: TransferDestinationViewModel) {
        let vc = DetailModule.build(with: DetailModule.Configuration(transferDestiation: transferDestiation))
        vc.modalPresentationStyle = .pageSheet
        viewController?.present(vc, animated: true)
    }
}
