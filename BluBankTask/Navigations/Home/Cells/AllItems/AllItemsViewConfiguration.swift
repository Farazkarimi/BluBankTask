//
//  AllItemsViewConfiguration.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit
import Combine

struct AllItemsViewConfiguration: UIContentConfiguration {

    let title: String
    let subtitle: String
    let imageURL: String
    var isFavorite: Bool

    var didTapOnFavorite = PassthroughSubject<Void, Never>()

    func makeContentView() -> UIView & UIContentView {
        let view = AllItemsView(configuration: self)
        let screenWidth = UIScreen.main.bounds.width
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        return view
    }

    func updated(for state: UIConfigurationState) -> Self {
        self
    }

    mutating func update(isFavorite: Bool) -> Self {
        self.isFavorite = isFavorite
        return self
    }
}
