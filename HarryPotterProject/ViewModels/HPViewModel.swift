//
//  HPViewModel.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 18/05/2025.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
final class HPViewModel: ObservableObject {
    @Published private(set) var images: [String: UIImage] = [:]
    @Published private(set) var state = State.idle
    @Published private(set) var isRefreshing = false

    @Published var savedEntities: [PhotoEntity] = []
    
    private let network: HPNetworking
    
    let container: NSPersistentContainer

    init(network: HPNetworking) {
        self.network = network
        
        container = NSPersistentContainer(name: "PhotosContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading core data. \(error)")
            } else {
                print("successfully loaded core data")
            }
        }
        fetchPhotos()
    }
    
    func fetchPhotos() {
        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
    }
    
    func addPhoto(text: String) {
        let newPhoto = PhotoEntity(context: container.viewContext)
        //newPhoto.name = text
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchPhotos()
        } catch let error {
            print("error saving data \(error)")
        }
    }

    func fetchData(refresh: Bool = false) async {
        if refresh {
            isRefreshing = true
        } else if state.isLoading {
            return
        } else {
            state = .loading
        }

        do {
            state = .loaded(characters: try await network.getHPCharacters())
            isRefreshing = false
            let imageDict = await downloadImagesFromUrl()

            self.images = imageDict
        } catch {
            state = .error(message: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }

    func downloadImagesFromUrl() async -> [String: UIImage] {
        guard let characters = state.characters else { return [:] }

        var resultImages = [String: UIImage]()

        await withTaskGroup(of: (String, UIImage).self) { group in
            for character in characters {
                if let url = URL(string: character.image) {
                    group.addTask {
                        await (character.id, self.network.fetchImage(url: url))
                    }
                }
            }

            for await (id, image) in group {
                resultImages[id] = image
            }
        }
        return resultImages
    }

    private func handleNetworkError(_ error: NetworkingError) async {
        let errorMessage = switch error {
        case .invalidURL:
            "Invalid URL. Please try again later."
        case .invalidResponse:
            "Invalid response from server. Please try again later."
        case .invalidStatusCode(let code):
            "Server error (code: \(code)). Please try again later."
        case .decodingFailed:
            "Failed to process data from server."
        case .requestFailed(let error):
            "Network request failed: \(error.localizedDescription)"
        case .otherError(let error):
            "Error: \(error.localizedDescription)"
        }

        state = .error(message: errorMessage)
    }
}

extension HPViewModel {
    enum State {
        case idle
        case loading
        case loaded(characters: [Character])
        case error(message: String)
    }
}

extension HPViewModel.State {
    var isLoading: Bool {
        switch self {
        case .loading: true
        default: false
        }
    }

    var characters: [Character]? {
        if case let .loaded(characters) = self {
            return characters
        }

        return nil
    }

    var isIdle: Bool {
        switch self {
        case .idle: true
        default: false
        }
    }
}
