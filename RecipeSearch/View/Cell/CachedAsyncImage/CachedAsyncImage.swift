import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                setup(image: Image(uiImage: image))
            } else {
                setup(image: Image(Images.placeholder))
            }
        }
        .task {
            await imageLoader.load(url: url)
        }
    }
}

// MARK: - Setup image

private extension CachedAsyncImage {
    @ViewBuilder
    func setup(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .clipped()
    }

    enum Images {
        static let placeholder = "placeholder"
    }
}
