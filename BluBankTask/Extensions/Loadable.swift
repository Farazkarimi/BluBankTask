//
//  Loadable.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum Loadable<T: Equatable> {
    case notRequested
    case isLoading(last: T? = nil)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last): return last
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }

    var isLoading: Bool {
        switch self {
        case  .isLoading: return true
        default: return false
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
        case (.isLoading(let lValue), .isLoading(let rValue)):
            return checkValue(lhsValue: lValue, rhsValue: rValue)
        case (.failed(let lhs), .failed(let rhs)):
            return rhs.localizedDescription == lhs.localizedDescription
        case (.notRequested, .notRequested):
            return true
        default:
            return false
        }
    }
}
