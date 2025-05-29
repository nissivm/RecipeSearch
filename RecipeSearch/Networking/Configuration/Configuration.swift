import Foundation

struct Configuration {
    static var appId: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "AppId") as? String else {
            return ""
        }
        return key
    }

    static var appKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "AppKey") as? String else {
            return ""
        }
        return key
    }
}
