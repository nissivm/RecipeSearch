import SwiftUI
import WebKit

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ZStack {
            backgroundImage

            if let url = recipe.url {
                WebView(url: url)
                    .edgesIgnoringSafeArea([.bottom])
            } else {
                VStack {
                    Text(Title.errorView)
                        .font(.title3)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(20)
                .padding(.horizontal, 40)
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
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
