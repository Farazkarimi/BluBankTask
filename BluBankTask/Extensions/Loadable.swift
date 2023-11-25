//
//  Loadable.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum Loadable<T: Equatable> {
    case initial
    case loading
    case loaded(T)
    case error(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        default: return nil
        }
    }
}

extension Loadable where T: Hashable {
    var hashableValue: T? { value }
}

extension Loadable: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        func checkValue(lhsValue: T?, rhsValue: T?) -> Bool {
            return lhsValue == rhsValue
        }

        switch (lhs, rhs) {
        case (.loaded(let lhsValue), .loaded(let rhsValue)):
            return checkValue(lhsValue: lhsValue, rhsValue: rhsValue)
        case (.loading, .loading):
            return true
        case (.error(let lhs), .error(let rhs)):
            return rhs.localizedDescription == lhs.localizedDescription
        case (.initial, .initial):
            return true
        default:
            return false
        }
    }
}
