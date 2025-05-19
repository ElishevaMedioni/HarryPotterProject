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
