import SwiftUI

struct ShimmerGridPlaceholderView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]
    
    private let placeholderCount = 8
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(0..<placeholderCount, id: \.self) { _ in
                ShimmerGridItem()
            }
        }
        .padding()
    }
}

struct ShimmerGridItem: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(2/3, contentMode: .fit)
                
                ShimmerView()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 100, height: 150)
            }
            .frame(height: 150)
            
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .frame(maxWidth: 80)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 10)
                    .frame(maxWidth: 60)
            }
            .padding(.top, 8)
        }
    }
}
