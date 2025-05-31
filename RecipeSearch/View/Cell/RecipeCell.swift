import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe

    var body: some View {
        ZStack {
            HStack {
                CachedAsyncImage(url: recipe.imageUrl)
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    
                    Text(recipe.cuisines)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(recipe.source)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: recipe.isFavorite ? Images.heartFill : Images.heart)
                    .foregroundColor(recipe.isFavorite ? .red : .gray)
                    .font(.title2)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

// MARK: - Components content

private extension RecipeCell {
    enum Images {
        static let heartFill = "heart.fill"
        static let heart = "heart"
    }
}

// MARK: - Cell Preview

#Preview {
    VStack {
        Spacer()
        RecipeCell(
            recipe: Recipe(
                id: "",
                name: "Rotisserie Chicken",
                source: "Serious Eats",
                cuisines: "mexican",
                imageUrl: nil,
                url: nil,
                isFavorite: false
            )
        )
        .padding(.horizontal, 24.0)
        Spacer()
    }
    .background(Color.gray)
}
