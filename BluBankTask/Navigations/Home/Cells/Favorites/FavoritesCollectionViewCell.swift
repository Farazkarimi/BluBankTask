//
//  FavoritesCollectionViewCell.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

final class FavoritesCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }
}

