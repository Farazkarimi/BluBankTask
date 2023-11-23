//
//  IndicatorCollectionViewCell.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

class IndicatorCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }
}
