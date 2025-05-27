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
                        GridView(
                            items: (0 ..< 10).map { .shimmering(id: String($0)) },
                            images: [:]
                        )
                        .transition(.opacity)
                    case let .loaded(characters):
                        GridView(
                            items: characters.map { .character($0) },
                            images: viewModel.images
                        )
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
                .transition(.opacity)
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

enum HPGridItem: Identifiable {
    case shimmering(id: String)
    case character(Character)

    var id: String {
        switch self {
        case let .shimmering(id):
            id
        case let .character(character):
            character.id
        }
    }
}

struct GridView: View {
    let items: [HPGridItem]
    let images: [String: UIImage]

    // Grid columns - adaptive for different device sizes
    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]

    var body: some View {
        if items.isEmpty {
            noCharacters
        } else {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(items) { item in
                    switch item {
                        case let .character(character):
                        CharacterGridItem(
                            character: character,
                            image: images[character.id]
                        )
                    case .shimmering:
                        ShimmerGridItem()
                    }
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
   // CharacterGridView(viewModel: HPViewModel())
}



