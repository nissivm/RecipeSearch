import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let cache = NSCache<NSString, UIImage>()

    func load(url: URL?) async {
        guard let url = url else { return }

        if let cachedImage = getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let loadedImage = UIImage(data: data) else {
                return
            }

            setImage(loadedImage, forKey: url.absoluteString)

            self.image = loadedImage
        } catch {}
    }
}

private extension ImageLoader {
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
