//
//  NetworkManager.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

protocol NetworkManagerProtocol {
    func sendArrayRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> [T]
}

class URLSessionNetworkManager: NetworkManagerProtocol {

    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case invalidResponse
        case decodingError
    }

    func sendArrayRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> [T] {
        let request = endpoint.makeUrlRequest()

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            do {
                let response = try JSONDecoder().decode([T].self, from: data)
                return response
            } catch {
                throw NetworkError.decodingError
            }

        } catch {
            throw NetworkError.requestFailed
        }
    }
}
