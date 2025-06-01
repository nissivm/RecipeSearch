import SwiftUI

struct RecipeCell: View {
    @ObservedObject private var recipe: Recipe
    private let manageRecipeClosure: () -> Void

    init(recipe: Recipe, manageRecipeClosure: @escaping @autoclosure () -> Void) {
        self.recipe = recipe
        self.manageRecipeClosure = manageRecipeClosure
    }

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
                    .onTapGesture {
                        manageRecipeClosure()
                    }
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
    let fakeRecipe = Recipe(
        id: "",
        name: "Rotisserie Chicken",
        source: "Serious Eats",
        cuisines: "mexican",
        imageUrl: nil,
        url: nil,
        isFavorite: false
    )

    VStack {
        Spacer()
        RecipeCell(
            recipe: fakeRecipe,
            manageRecipeClosure: { fakeRecipe.isFavorite.toggle() }()
        )
        .padding(.horizontal, 24.0)
        Spacer()
    }
    .background(Color.gray)
}
