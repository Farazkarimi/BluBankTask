//
//  HeaderCollectionReusableView.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView, ReusableCell {

    @IBOutlet private weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    func configHeader(with title: String) {
        titleLabel.text = title
    }
}
