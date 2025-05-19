//
//  CharacterGridItemView.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 18/05/2025.
//

import SwiftUI

struct CharacterGridItemView: View {
    let character: Character
    let image: UIImage?
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(2/3, contentMode: .fit)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 3)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 150)
            
            VStack(spacing: 4) {
                Text(character.nickname)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(character.hogwartsHouse.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
    }
}
