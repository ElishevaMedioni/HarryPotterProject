//
//  HarryPotterProjectApp.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import SwiftUI

@main
struct HarryPotterProjectApp: App {
    @StateObject private var viewModel = HPViewModel()
    
    var body: some Scene {
        WindowGroup {
            CharacterGridView(viewModel: viewModel)
        }
    }
}
