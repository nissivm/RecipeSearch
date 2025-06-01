import SwiftUI

struct SearchedRecipesView: View {
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
            case .success(let recipes):
                List {
                    ForEach(recipes) { recipe in
                        RecipeCell(recipe: recipe)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                task = Task {
                                    await viewModel.fetchMoreRecipes(recipe)
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
        .taskFirstAppear {
            await viewModel.fetchRecipes()
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
                        await viewModel.fetchRecipes()
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
