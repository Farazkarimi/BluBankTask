//
//  ReusableCell.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

public protocol ReusableCell: AnyObject {
    static var cellIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableCell {
    public static var cellIdentifier: String { className(of: self) }
    public static var nib: UINib { UINib(nibName: className(of: self), bundle: Bundle(for: self)) }
}
