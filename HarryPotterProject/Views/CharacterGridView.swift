//
//  CharacterGridView.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import SwiftUI

struct CharacterGridView: View {
    @ObservedObject  var viewModel: HPViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    switch viewModel.state {
                    case .loading:
                        ShimmerGridPlaceholderView()
                            .transition(.opacity)
                    case let .loaded(characters: characters):
                        CharactersView(characters: characters, images: viewModel.images)
                            .transition(.opacity)
                    case let .error(message):
                        ErrorView(
                            errorMessage: message,
                            retryAction: { await viewModel.fetchData() }
                        )
                    case .idle:
                        EmptyView()
                    }
                }
//                .animation(.easeInOut(duration: 0.4), value: viewModel.isLoading)
            }
            .navigationTitle("Harry Potter Characters")
            .task {
                if viewModel.state.isIdle {
                    await viewModel.fetchData()
                }
            }
            .refreshable {
                await viewModel.fetchData(refresh: true)
            }
        }
    }
}

struct CharactersView: View {
    let characters: [Character]
    let images: [UUID: UIImage]

    // Grid columns - adaptive for different device sizes
    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]

    var body: some View {
        if characters.isEmpty {
            noCharacters
        } else {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(characters) { character in
                    CharacterGridItem(character: character, image: images[character.id])
                }
            }
            .padding()
        }
    }

    // Empty state view
    private var noCharacters: some View {
        Text("No characters to display")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 100)
    }
}

#Preview {
    CharacterGridView(viewModel: HPViewModel())
}



