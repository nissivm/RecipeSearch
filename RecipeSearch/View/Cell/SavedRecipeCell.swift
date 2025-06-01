import SwiftUI

struct SavedRecipeCell: View {
    let recipe: SavedRecipe

    var body: some View {
        ZStack {
            HStack {
                CachedAsyncImage(url: recipe.imageUrl)
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    
                    Text(recipe.cuisines)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text(recipe.source)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            .padding()
        }
        .background(Color("bege"))
        .cornerRadius(20)
    }
}

// MARK: - Cell Preview

#Preview {
    VStack {
        Spacer()
        SavedRecipeCell(
            recipe: SavedRecipe(
                id: "",
                name: "Rotisserie Chicken",
                source: "Serious Eats",
                cuisines: "mexican",
                imageUrl: nil,
                url: nil
            )
        )
        .padding(.horizontal, 24.0)
        Spacer()
    }
    .background(Color.gray)
}
