//
//  FavoritesViewConfiguration.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

struct FavoritesViewConfiguration: UIContentConfiguration {

    let title: String
    let subtitle: String
    let imageURL: String

    func makeContentView() -> UIView & UIContentView {
        let view = FavoritesView(configuration: self)
        let screenWidth = UIScreen.main.bounds.width
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        return view
    }

    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}
