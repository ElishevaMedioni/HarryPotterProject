//
//  NetworkManager.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//


import Foundation
import UIKit

final class NetworkManager {
    
    //Singleton - it is recommended for things like NetworkManager to be Singleton
    static let shared = NetworkManager()
    
    private let baseURL = "https://potterapi-fedeperin.vercel.app/en"
    private var charactersURL: String {
        return baseURL + "/characters"
    }
    
    private init() {}
    
    func getHPCharacters() async throws -> [Character] {
        guard let url = URL(string: charactersURL) else {
            throw URLError(.badURL)
        }
        
        // Use URLSession to fetch the data asynchronously.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // check response and data
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkingError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        // decode JSON response
        do {
            let decodedResponse = try JSONDecoder().decode([Character].self, from: data)
            return decodedResponse
        } catch let error as DecodingError {
            throw NetworkingError.decodingFailed(innerError: error)
        }
    }
    
    //add check error
    func fetchImage(url: URL) async -> UIImage {
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
}

//func testNetworkCallInConsole() {
//    // Create and start a task to run the async network call
//    Task {
//        print("🔄 Starting network test...")
//        
//        do {
//            let startTime = Date()
//            let characters = try await NetworkManager.shared.getHPCharacters()
//            let timeElapsed = Date().timeIntervalSince(startTime)
//            
//            print("✅ SUCCESS! Retrieved \(characters.count) characters in \(String(format: "%.2f", timeElapsed))s")
//            
//            // Print summary of first few characters
//            print("\n--- First 3 Characters ---")
//            for (index, character) in characters.prefix(3).enumerated() {
//                print("\nCharacter \(index + 1): \(character.fullName)")
//                print("  House: \(character.hogwartsHouse.rawValue)")
//                print("  Actor: \(character.interpretedBy)")
//                print("  Birthdate: \(character.birthdate)")
//                print("  Image: \(character.image)")
//                print("  Children: \(character.children.isEmpty ? "None" : character.children.joined(separator: ", "))")
//            }
//            
//            // Print some statistics
//            let houses = Dictionary(grouping: characters) { $0.hogwartsHouse }
//            print("\n--- House Statistics ---")
//            houses.forEach { house, characters in
//                print("\(house.rawValue): \(characters.count) characters")
//            }
//            
//        } catch NetworkingError.invalidURL {
//            print("❌ ERROR: Invalid URL - Check the URL construction")
//        } catch NetworkingError.invalidResponse {
//            print("❌ ERROR: Invalid response from server - Response wasn't HTTP")
//        } catch NetworkingError.invalidStatusCode(let code) {
//            print("❌ ERROR: Invalid status code \(code) - Expected 200")
//        } catch NetworkingError.decodingFailed(let error) {
//            print("❌ ERROR: Failed to decode JSON")
//            print("Details: \(error)")
//            
//            // Provide more specific information about decoding errors
//            switch error {
//            case .typeMismatch(let type, let context):
//                print("  Type mismatch: Expected \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
//            case .valueNotFound(let type, let context):
//                print("  Value not found: Expected \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
//            case .keyNotFound(let key, let context):
//                print("  Key not found: \(key.stringValue) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
//            case .dataCorrupted(let context):
//                print("  Data corrupted: \(context.debugDescription)")
//            @unknown default:
//                print("  Unknown decoding error")
//            }
//        } catch NetworkingError.requestFailed(let error) {
//            print("❌ ERROR: Network request failed")
//            print("Details: \(error)")
//        } catch {
//            print("❌ ERROR: Unknown error occurred")
//            print("Details: \(error)")
//        }
//    }
//}
