//
//  CharacterGridView.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import SwiftUI

struct CharacterGridView: View {
    @ObservedObject  var viewModel: HPViewModel
    
    // Grid columns - adaptive for different device sizes
    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    if viewModel.isLoading {
                        ShimmerGridPlaceholderView()
                            .transition(.opacity)
                    }
                    else if !viewModel.characters.isEmpty {
                        charactersGrid
                            .transition(.opacity)
                    } else if viewModel.hasError {
                        ErrorView(
                            errorMessage: viewModel.errorMessage ?? "",
                            retryAction: { viewModel.fetchData() })
                    } else {
                        emptyView
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: viewModel.isLoading)
            }
            
            .navigationTitle("Harry Potter Characters")
            .onAppear {
                if viewModel.characters.isEmpty {
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
            ForEach(viewModel.characters) { character in
                CharacterGridItem(character: character, image: viewModel.images[character.id])
            }
        }
        .padding()
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
    CharacterGridView(viewModel: HPViewModel())
}



