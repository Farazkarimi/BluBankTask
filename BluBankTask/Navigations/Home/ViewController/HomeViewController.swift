//
//  HomeViewController.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

class HomeViewController: UIViewController {

    private var viewModel: HomeViewModelProtocol

    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
