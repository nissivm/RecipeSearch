import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe

    var body: some View {
        ZStack {
            HStack {
                AsyncImage(url: recipe.imageUrl) { phase in
                    if let image = phase.image {
                        setup(image: image)
                    } else {
                        setup(image: Image(Images.placeholder))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                        .lineLimit(1)
                    
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

// MARK: - Image setup

private extension RecipeCell {
    @ViewBuilder
    func setup(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .clipped()
    }
}

// MARK: - Components content

private extension RecipeCell {
    enum Images {
        static let placeholder = "placeholder"
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
