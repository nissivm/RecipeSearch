import SwiftUI
import SwiftData

struct SearchedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedRecipe.name, order: .forward) private var saved: [SavedRecipe]
    @ObservedObject var viewModel: SearchedRecipesViewModel

    @StateObject private var coordinator = AppCoordinator.shared
    @State private var task: Task<Void, Never>?

    var body: some View {
        ZStack {
            backgroundImage

            switch viewModel.searchState {
            case .loading:
                loadingView
            case .error:
                errorView
            case .success:
                if viewModel.allRecipes.isEmpty {
                    ErrorView(text: Title.errorView)
                } else {
                    List {
                        ForEach(viewModel.allRecipes) { recipe in
                            RecipeCell(recipe: recipe,
                                       manageRecipeClosure: viewModel.manageRecipe(recipe, using: modelContext, and: saved))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                task = Task {
                                    await viewModel.fetchMoreRecipes(recipe, checkSavedUsing: saved)
                                }
                            }
                            .onTapGesture {
                                coordinator.navigateToRecipeDetailView(using: recipe)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding()
                }
            }
        }
        .navigationTitle(Title.screen)
        .customBackButton()
        .taskFirstAppear {
            await viewModel.fetchRecipes(checkSavedUsing: saved)
        }
        .onDisappear {
            task?.cancel()
        }
        .navigationDestination(for: Recipe.self) { recipe in
            ScreenAssembler.recipeDetailView(using: recipe)
        }
    }
}

// MARK: - Screen components

private extension SearchedRecipesView {
    @ViewBuilder
    var backgroundImage: some View {
        Image(Images.background)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }

    @ViewBuilder
    var loadingView: some View {
        ZStack {
            ProgressView(Constants.progressViewTitle)
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
        .frame(width: 220)
    }

    @ViewBuilder
    var errorView: some View {
        VStack {
            Spacer()
            VStack {
                Text(Constants.errorViewTitle)
                    .font(.title3)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 16)

                Button(action: {
                    task = Task {
                        await viewModel.fetchRecipes(checkSavedUsing: saved)
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(Constants.tryAgainButtonTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 40)
                        Spacer()
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .background(Color.white.opacity(0.8))
            .cornerRadius(20)
            .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Components content

private extension SearchedRecipesView {
    enum Title {
        static let screen = "Search results"
        static let errorView = "OOps, we don't have any recipes for your ingredient, please try again with another one 🙂"
    }

    enum Images {
        static let background = "background"
        static let backButton = "chevron.left"
    }

    enum Constants {
        static let progressViewTitle = "Loading Recipes..."
        static let errorViewTitle = "OOps, something went wrong while fetching recipes!"
        static let tryAgainButtonTitle = "Try again"
    }
}

// MARK: - Screen Preview

#Preview("List of recipes") {
    SearchedRecipesView(
        viewModel: SearchedRecipesViewModel(
            searchData: SearchData(ingredient: "", cuisine: ""),
            apiClient: PreviewUtils.FakeAPIClient(shouldThrow: false)
        )
    )
}

#Preview("Error view") {
    SearchedRecipesView(
        viewModel: SearchedRecipesViewModel(
            searchData: SearchData(ingredient: "", cuisine: ""),
            apiClient: PreviewUtils.FakeAPIClient(shouldThrow: true)
        )
    )
}
