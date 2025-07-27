import SwiftUI

struct InitialView: View {
    @State private var showIngredientInput: Bool = false
    @State private var ingredientInputOpacity: Double = 0
    @State private var ingredient: String = ""
    @State private var showStartSearchButton: Bool = false
    @State private var showPicker: Bool = false
    @State private var selectedCuisine: String = "Any Cuisine"
    @FocusState private var isTextFieldFocused: Bool
    let viewModel: InitialViewModel

    @StateObject private var coordinator = AppCoordinator.shared

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                backgroundImage
                
                VStack {
                    Spacer()

                    searchRecipesButton

                    if showIngredientInput {
                        VStack {
                            ingredientTextField

                            selectCuisineButton

                            if showStartSearchButton {
                                startSearchButton
                            }
                            
                            if showPicker {
                                cuisinePicker
                            }
                        }
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .opacity(ingredientInputOpacity)
                    }

                    myRecipesButton
                    
                    Spacer()
                }
            }
            .navigationTitle(viewModel.screenTitle)
            .navigationDestination(for: SearchData.self) { data in
                ScreenAssembler.searchedRecipesView(using: data)
            }
            .navigationDestination(for: String.self) { _ in
                ScreenAssembler.savedRecipesView()
            }
        }
    }
}

// MARK: - Screen components

private extension InitialView {
    @ViewBuilder
    var backgroundImage: some View {
        Image(Images.background)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
            .onTapGesture {
                isTextFieldFocused = false
            }
    }

    @ViewBuilder
    var searchRecipesButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.5)) {
                showIngredientInput.toggle()
                
                if !showIngredientInput {
                    showPicker = false
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    if self.ingredientInputOpacity == 0.0 {
                        self.ingredientInputOpacity = 1
                    } else {
                        self.ingredientInputOpacity = 0
                    }
                }
            }
        }) {
            Text(viewModel.searchRecipesButtonTitle)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.lightCobalt)
                .cornerRadius(15)
        }
        .padding(.horizontal, 40)
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    var ingredientTextField: some View {
        TextField(viewModel.textFieldPlaceholder, text: $ingredient)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { _, _ in
                if isTextFieldFocused {
                    withAnimation {
                        showPicker = false
                    }
                }
            }
            .onChange(of: ingredient) { _, _ in
                showStartSearchButton = viewModel.hasLetters(ingredient)
            }
    }

    @ViewBuilder
    var selectCuisineButton: some View {
        Button(action: {
            withAnimation {
                showPicker.toggle()
                isTextFieldFocused = false
            }
        }) {
            HStack {
                Text(selectedCuisine)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                    .frame(height: 30)
                Spacer()
                Image(systemName: Images.searchIcon)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
            .background(Color.orange)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    var startSearchButton: some View {
        Button(action: {
            let searchData = SearchData(
                ingredient: ingredient,
                cuisine: viewModel.searchDataCuisine(selectedCuisine)
            )
            coordinator.navigateToSearchedRecipes(using: searchData)
        }) {
            HStack {
                Spacer()
                Text(viewModel.startSearchButtonTitle)
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

    @ViewBuilder
    var cuisinePicker: some View {
        Picker(viewModel.cuisinePickerTitle, selection: $selectedCuisine) {
            ForEach(viewModel.cuisines, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 120)
        .background(Color.white)
    }

    @ViewBuilder
    var myRecipesButton: some View {
        Button(action: {
            coordinator.navigateToMyRecipes()
        }) {
            Text(viewModel.myRecipesButtonTitle)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.cobalt)
                .cornerRadius(15)
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Components content

private extension InitialView {
    enum Images {
        static let background = "background"
        static let searchIcon = "magnifyingglass"
    }
}

// MARK: - Screen Preview

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(viewModel: InitialViewModel())
    }
}
