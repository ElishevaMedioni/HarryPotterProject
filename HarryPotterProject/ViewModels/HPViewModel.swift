//
//  HPViewModel.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 18/05/2025.
//

import Foundation
import SwiftUI

final class HPViewModel: ObservableObject {
    
    @Published private(set) var characters: [Character] = []
    @Published private(set) var images: [UUID: UIImage] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false
    @Published private(set) var errorMessage: String?
    
    func fetchData() {
        guard !isLoading else { return }
        isLoading = true
        hasError = false
        errorMessage = nil
        
        Task {
            do {
                self.characters = try await NetworkManager.shared.getHPCharacters()
                let imageDict = await downloadImagesFromUrl()
                
                await MainActor.run { //update on main thread
                    self.images = imageDict
                    self.isLoading = false
                }
            } catch {
                // handle error
                await MainActor.run {
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    func refreshData() async {
            // For pull-to-refresh functionality
            await MainActor.run {
                isLoading = true
                hasError = false
                errorMessage = nil
            }
            
            do {
                let characters = try await NetworkManager.shared.getHPCharacters()
                await MainActor.run { self.characters = characters }
                
                let imageDict = await downloadImagesFromUrl()
                
                await MainActor.run {
                    self.images = imageDict
                    self.isLoading = false
                }
            } catch let error as NetworkingError {
                await handleNetworkError(error)
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
            }
        }
    
    
    func downloadImagesFromUrl() async -> [UUID:UIImage] {
        var resultImages = [UUID: UIImage]()
        
         await withTaskGroup(of: (UUID,UIImage).self) { group in
             for character in characters {
                 if let url = URL(string: character.image) {
                    group.addTask {
                        await (character.id ,NetworkManager.shared.fetchImage(url: url))
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
            await MainActor.run {
                self.isLoading = false
                self.hasError = true
                
                switch error {
                case .invalidURL:
                    self.errorMessage = "Invalid URL. Please try again later."
                case .invalidResponse:
                    self.errorMessage = "Invalid response from server. Please try again later."
                case .invalidStatusCode(let code):
                    self.errorMessage = "Server error (code: \(code)). Please try again later."
                case .decodingFailed:
                    self.errorMessage = "Failed to process data from server."
                case .requestFailed(let error):
                    self.errorMessage = "Network request failed: \(error.localizedDescription)"
                case .otherError(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
}
