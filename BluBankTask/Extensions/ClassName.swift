//
//  ClassName.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

///Get class name as string
public func className(of aClass: AnyClass) -> String {
    return String(describing: aClass.self)
}
