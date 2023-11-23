//
//  AllItemsView.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit
import Combine

final class AllItemsView: UIView, UIContentView, Xibbed {

    private enum Constant {
        static let starImageName = "star"
        static let starFilledImageName = "star.fill"
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    private var viewConfiguration: AllItemsViewConfiguration? {
        configuration as? AllItemsViewConfiguration
    }

    var configuration: UIContentConfiguration {
        didSet {
            updateConfiguration()
        }
    }

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        xibSetup()
        updateConfiguration()
        imageView.layer.cornerRadius = HomeViewController.Constant.allItemHeight/2
    }

    required init?(coder: NSCoder) {
        self.configuration = AllItemsViewConfiguration(title: "", subtitle: "", imageURL: "", isFavorite: false)
        super.init(coder: coder)
        setup()
    }

    private func updateConfiguration() {
        guard let configuration = viewConfiguration else { return }
        titleLabel.text = configuration.title
        subtitleLabel.text = configuration.subtitle
        favoriteButton.setImage(UIImage(systemName: configuration.isFavorite ? Constant.starFilledImageName : Constant.starImageName), for: .normal)
        imageView.loadImage(fromURL: configuration.imageURL)
    }

    @IBAction func onFavoriteButtonTapped(_ sender: UIButton) {
        viewConfiguration?.didTapOnFavorite.send()
    }
}
