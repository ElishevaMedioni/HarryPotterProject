//
//  HPNetwork+Production.swift
//  HarryPotterProject
//
//  Created by Natan Rolnik on 20/05/2025.
//

import Foundation
import UIKit

protocol Endpoint {
    var path: String { get }
    var method: String { get }
}

enum HPEndpoint {
    case characters
    case houses
}

extension HPEndpoint: Endpoint {
    var path: String {
        switch self {
        case .characters: "characters"
        case .houses: "houses"
        }
    }
    
    var method: String {
        switch self {
        case .characters,
                .houses:
            "GET"
        }
    }
}

extension HPNetwork {
    static let production = HPNetwork(
        getCharacters: {
            try await GenericNetwork.hpAPI.execute(HPEndpoint.characters)
        },
        fetchImage: { url in
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return UIImage(systemName: "person.fill") ?? UIImage()
                }

                if let img = UIImage(data: data) { return img }

            } catch {
                print("Error downloading image from \(url): \(error)")
            }
            return UIImage(systemName: "person.fill") ?? UIImage()
        }
    )
}
