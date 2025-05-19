//
//  NetworkingError.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    //case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)
}
