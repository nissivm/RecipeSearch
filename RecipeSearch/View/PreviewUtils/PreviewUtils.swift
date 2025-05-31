import Foundation

struct PreviewUtils {
    struct FakeAPIClient: APIClientProtocol {
        let shouldThrow: Bool

        func execute<T>(type: T.Type, with requestable: any URLRequestable) async throws -> T where T : Decodable {
            if shouldThrow {
                throw RecipeSearchError.jsonDecodingFailure
            } else {
                return testModel as! T
            }
        }
        
        func executeNext<T>(type: T.Type, with url: URL) async throws -> T where T : Decodable {
            testModel as! T
        }

        var testModel: RecipeSearchModel {
            RecipeSearchModel(
                links: nil,
                hits: [
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Shredded chicken",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "BBC Good Food",
                        url: "",
                        cuisineType: ["american"]
                    )),
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Rotisserie Chicken Recipe",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "Serious Eats",
                        url: "",
                        cuisineType: ["mexican"]
                    )),
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Teriyaki Chicken",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "David Lebovitz",
                        url: "",
                        cuisineType: ["asian", "japanese"]
                    )),
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Chicken Paprikash",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "No Recipes",
                        url: "",
                        cuisineType: ["central europe"]
                    )),
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Slow Cooker Shredded Chicken",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "The Kitchen",
                        url: "",
                        cuisineType: ["american"]
                    )),
                    Hit(recipe: CodableRecipe(
                        uri: "",
                        label: "Chicken Tonnato",
                        images: Images(regular: RecipeImage(url: "", width: 100, height: 100)),
                        source: "Martha Stewart",
                        url: "",
                        cuisineType: ["japanese"]
                    ))
                ]
            )
        }
    }
}
