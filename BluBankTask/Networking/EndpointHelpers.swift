//
//  EndpointHelpers.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var queryParams: [String: Any]? { get }
}

extension EndpointProtocol {

    func makeUrlRequest() -> URLRequest {
        guard let url = URL(string: baseURL)?.appending(path: path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { fatalError("Invalid base URL") }

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue

        if let queryParams = queryParams {
            if method == .GET {
                var queryItems: [URLQueryItem] = []
                for (key, value) in queryParams {
                    let queryItem = URLQueryItem(name: key, value: String(describing: value))
                    queryItems.append(queryItem)
                }
                components.queryItems = queryItems
                request.url = components.url

            } else {
                do {
                    let data = try JSONSerialization.data(withJSONObject: queryParams)
                    request.httpBody = data
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
        }

        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}


