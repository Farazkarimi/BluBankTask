//
//  TransferEndPoints.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum TransferEndpoints {
    case getTransferList(Int)
}

extension TransferEndpoints: EndpointProtocol {
    var baseURL: String {
        Environment.baseURL
    }

    var path: String {
        switch self {
        case .getTransferList:
            return "transfer-list/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTransferList:
               return .GET
        }
    }

    var queryParams: [String : Any]? {
        switch self {
        case let .getTransferList(page):
            return["page":"\(page)"]
        default:
            return nil
        }
    }

    var header: [String: String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
}

