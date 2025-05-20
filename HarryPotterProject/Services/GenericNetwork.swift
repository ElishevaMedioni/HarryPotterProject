//
//  GenericNetwork.swift
//  HarryPotterProject
//
//  Created by Natan Rolnik on 20/05/2025.
//

import Foundation

struct GenericNetwork {
    let baseURL: URL

    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method

        // Use URLSession to fetch the data asynchronously.
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // check response and data
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkingError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }

        // decode JSON response
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch let error as DecodingError {
            throw NetworkingError.decodingFailed(innerError: error)
        }
    }
}
