//
//  AnotherNetwork.swift
//  HarryPotterProject
//
//  Created by Natan Rolnik on 20/05/2025.
//

import Foundation
import UIKit

struct HPNetwork {
    let getCharacters: () async throws -> [Character]
    let fetchImage: (URL) async -> UIImage
}

extension GenericNetwork {
    static let hpAPI = GenericNetwork(baseURL: URL(string: "https://potterapi-fedeperin.vercel.app/en")!)
    static let localAPI = GenericNetwork(baseURL: URL(string: "http://localhost:8080")!)
}

// 1. Inject class
// 2. Inject protocol (also in preview) - useful for previews, test
// 3. Inject base URL
// 4. Inject struct (protocol witness)
