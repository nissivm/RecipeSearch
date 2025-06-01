import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedRecipe.name, order: .forward) private var saved: [SavedRecipe]
    let viewModel: SavedRecipesViewModel

    @StateObject private var coordinator = AppCoordinator.shared

    var body: some View {
        ZStack {
            backgroundImage

            List {
                ForEach(saved) { savedRecipe in
                    SavedRecipeCell(recipe: savedRecipe)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            let recipe = viewModel.mapRecipeFromSavedRecipe(savedRecipe)
                            coordinator.navigateToRecipeDetailView(using: recipe)
                        }
                }
                .onDelete { indexSet in
                    viewModel.delete(from: saved, in: indexSet, using: modelContext)
                }
            }
            .listStyle(.plain)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                coordinator.pop()
            }) {
                Image(systemName: Images.backButton)
                    .foregroundColor(.white)
            }
        )
        .navigationTitle(Title.screen)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Recipe.self) { recipe in
            ScreenAssembler.recipeDetailView(using: recipe)
        }
    }
}

// MARK: - Screen components

private extension SavedRecipesView {
    @ViewBuilder
    var backgroundImage: some View {
        Image(Images.background)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
}

// MARK: - Components content

private extension SavedRecipesView {
    enum Title {
        static let screen = "My Recipes"
    }

    enum Images {
        static let background = "background"
        static let backButton = "chevron.left"
    }
}
