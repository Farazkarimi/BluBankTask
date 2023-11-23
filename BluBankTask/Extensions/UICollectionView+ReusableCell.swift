//
//  UICollectionView+ReusableCell.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

extension UICollectionViewCell: ReusableCell {}

public extension UICollectionView {

    func registerCellTypeForNib<Cell: ReusableCell>(_ cellType: Cell.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.cellIdentifier)
    }

    func registerCellTypeForClass<Cell: ReusableCell>(_ cellType: Cell.Type) {
        register(cellType, forCellWithReuseIdentifier: Cell.cellIdentifier)
    }

    func dequeueReusableCellType<Cell: ReusableCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.cellIdentifier, for: indexPath) as? Cell else { fatalError("Cannot deque reusable cell") }
        return cell
    }
}
