import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedRecipe.name, order: .forward) private var saved: [SavedRecipe]
    let viewModel: SavedRecipesViewModel

    @StateObject private var coordinator = AppCoordinator.shared

    var body: some View {
        ZStack {
            if saved.isEmpty {
                ErrorView(text: viewModel.errorViewTitle)
            } else {
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
        }
        .background(Color.softCobalt)
        .navigationTitle(viewModel.screenTitle)
        .customBackButton()
        .navigationDestination(for: Recipe.self) { recipe in
            ScreenAssembler.recipeDetailView(using: recipe)
        }
    }
}

// MARK: - Components content

private extension SavedRecipesView {
    enum Images {
        static let background = "background"
        static let backButton = "chevron.left"
    }
}
