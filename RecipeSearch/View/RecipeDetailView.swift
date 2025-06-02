import SwiftUI
import WebKit

struct RecipeDetailView: View {
    let recipe: Recipe

    @StateObject private var coordinator = AppCoordinator.shared

    var body: some View {
        ZStack {
            backgroundImage

            if let url = recipe.url {
                WebView(url: url)
                    .edgesIgnoringSafeArea([.bottom])
            } else {
                ErrorView(text: Title.errorView)
            }
        }
        .navigationTitle(recipe.name)
        .customBackButton()
    }
}

// MARK: - Screen components

private extension RecipeDetailView {
    @ViewBuilder
    var backgroundImage: some View {
        Image(Images.background)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
}

// MARK: - Components content

private extension RecipeDetailView {
    enum Images {
        static let background = "background"
        static let backButton = "chevron.left"
    }

    enum Title {
        static let errorView = "Something went wrong with recipe's URL 😕"
    }
}

// MARK: - Screen Preview

#Preview("Error view") {
    RecipeDetailView(
        recipe: Recipe(
            id: "",
            name: "",
            source: "",
            cuisines: "",
            imageUrl: nil,
            url: nil,
            isFavorite: false
        )
    )
}

// MARK: - View representable for WKWebView

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
