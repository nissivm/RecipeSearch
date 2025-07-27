import SwiftUI
import SwiftData

@main
struct RecipeSearchApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "cobalt")

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ScreenAssembler.initialView()
        }
        .modelContainer(for: SavedRecipe.self)
    }
}
