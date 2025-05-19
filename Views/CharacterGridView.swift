//
//  CharacterGridView.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import SwiftUI

struct CharacterGridView: View {
    @StateObject private var viewModel = HPViewModel()
    
    // Grid columns - adaptive for different device sizes
    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    loadingView
                } else if !viewModel.charactersData.isEmpty {
                    charactersGrid
                } else if viewModel.hasError {
                    errorView
                } else {
                    emptyView
                }
            }
            .navigationTitle("Harry Potter Characters")
            .onAppear {
                if viewModel.charactersData.isEmpty {
                    viewModel.fetchData()
                }
            }
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
    
    // Character grid layout
    private var charactersGrid: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(viewModel.charactersData) { character in
                CharacterGridItem(character: character, image: viewModel.images[character.id])
            }
        }
        .padding()
    }
    
    // Loading view with progress indicator
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading characters...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
    
    // Error message view
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Couldn't load characters")
                .font(.headline)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Try Again") {
                viewModel.fetchData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Empty state view
    private var emptyView: some View {
        Text("No characters to display")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 100)
    }
}

#Preview {
    CharacterGridView()
}



