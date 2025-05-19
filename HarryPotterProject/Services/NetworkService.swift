//
//  NetworkService.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 19/05/2025.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: URL) async throws -> T
    func fetchImage(from url: URL) async -> UIImage?
}

final class NetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkingError.invalidStatusCode(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch let error as DecodingError{
            throw NetworkingError.decodingFailed(innerError: error)
        }
    }

    func fetchImage(from url: URL) async -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else { return nil }
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
