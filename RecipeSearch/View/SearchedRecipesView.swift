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
            switch viewModel.searchState {
            case .loading:
                loadingView
            case .error:
                errorView
            case .success:
                if viewModel.allRecipes.isEmpty {
                    ErrorView(text: viewModel.errorViewScreenTitle)
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
        .background(viewModel.searchState == .success ? Color.softCobalt : Color.white)
        .navigationTitle(viewModel.screenTitle)
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
    var loadingView: some View {
        ZStack {
            ProgressView(viewModel.progressViewTitle)
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.softCobalt.opacity(0.8))
        .cornerRadius(20)
        .frame(width: 220)
    }

    @ViewBuilder
    var errorView: some View {
        VStack {
            Spacer()
            VStack {
                Text(viewModel.errorViewTitle)
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
                        Text(viewModel.tryAgainButtonTitle)
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
            .background(Color.softCobalt.opacity(0.8))
            .cornerRadius(20)
            .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Components content

private extension SearchedRecipesView {
    enum Images {
        static let background = "background"
        static let backButton = "chevron.left"
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
