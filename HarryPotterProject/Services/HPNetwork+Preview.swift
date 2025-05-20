//
//  HPNetwork+Preview.swift
//  HarryPotterProject
//
//  Created by Natan Rolnik on 20/05/2025.
//

import Foundation

extension HPNetwork {
    static let preview = HPNetwork(
        getCharacters: {
            try await Task.sleep(for: .milliseconds(1200))
            let jsonData = charactersResponse.data(using: .utf8)!
            return try JSONDecoder().decode([Character].self, from: jsonData)
        },
        fetchImage: { _ in .hermione }
    )
}
