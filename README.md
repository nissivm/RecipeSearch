<h1 align="center">Recipe search, by Nissi Miranda</h1>

**Recipe search** is an app to search for recipes, by inputing an ingredient and choosing a cuisine. You can include all cuisines, by not chosing a particular one. You can also save your favorite recipes.

The API comes from https://www.edamam.com/

The app was made 100% in SwiftUI and uses SwiftData to save locally user's favorite recipes.
For testing, it's used XCTest framework.
For fetching the recipes, we use Swift Concurrency (async/await).

## Architecture

For the architeture, it was used MVVM. App also has a Networking layer, responsible for holding API client, models and everything else needed to make the API requsts.

## How to run it?

- Open project in Xcode (project was developed in version 16.3, so is advisable to use this same version).
- Make sure you include a Team, in RecipeSearch target, in case you want to run app in an actual device. But you can also run it in simulator.

## About the screens:

### 1. First screen: IntialView

From there you can start a search or go to your favorite recipes

### 2. SearchedRecipesView

Showcases the results of a search. From there, you can also save/delete recipes, by tapping the ♥️
By scrolling, program automatically fetches more recipes (Pagination).

### 3. RecipeDetailView

Shows the details of a recipe, by loading it's page from the web

### 4. SavedRecipesView

Showcases user's saved recipes. You can delete recipes from there as well, by sliding to the left.

