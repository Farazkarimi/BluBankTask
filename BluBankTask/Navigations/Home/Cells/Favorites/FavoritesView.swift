//
//  FavoritesView.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

final class FavoritesView: UIView, UIContentView, Xibbed {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    private var viewConfiguration: FavoritesViewConfiguration? {
        configuration as? FavoritesViewConfiguration
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
        imageView.layer.cornerRadius = 60/2
    }

    required init?(coder: NSCoder) {
        self.configuration = FavoritesViewConfiguration(title: "", subtitle: "", imageURL: "")
        super.init(coder: coder)
        setup()
    }


    private func updateConfiguration() {
        guard let configuration = viewConfiguration else { return }
        titleLabel.text = configuration.title
        subtitleLabel.text = configuration.subtitle
        imageView.loadImage(fromURL: configuration.imageURL)
    }
}
