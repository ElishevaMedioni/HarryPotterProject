//
//  HarryPotterProjectApp.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import SwiftUI

@main
struct HarryPotterProjectApp: App {
    // used dependency injection - if I want to inject an other network layer I can easily
    @StateObject private var viewModel = HPViewModel(network: NetworkManager())
    
    var body: some Scene {
        WindowGroup {
            CharacterGridView(viewModel: viewModel)
        }
    }
}
