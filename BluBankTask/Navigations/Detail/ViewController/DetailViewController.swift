//
//  DetailViewController.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    enum Constant {
        static let starImageName = "star"
        static let starFilledImageName = "star.fill"
    }

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var transferCountLabel: UILabel!

    @IBOutlet weak var favoriteButton: UIButton!
    
    let viewModel: DetailViewModelProtocol
    private var cancellables: Set<AnyCancellable> =  .init()

    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func bind() {
        viewModel.state
            .map(\.transferDestiation)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] model in
                guard let self else { return }
                self.update(model: model)
            }.store(in: &cancellables)
    }

    private func update(model: TransferDestinationViewModel) {
        avatarImageView.loadImage(fromURL: model.avatar)
        nameLabel.text = model.fullName
        emailLabel.text = model.email
        cardNumberLabel.text = model.cardNumber
        transferCountLabel.text = "\(model.numberOfTransfers)"
        favoriteButton.setImage(UIImage(systemName: model.isFavorite ? Constant.starFilledImageName : Constant.starImageName), for: .normal)
    }

    @IBAction private func favoriteButtonAction(_ sender: UIButton) {

    }
}
