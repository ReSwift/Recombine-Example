import Combine
import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {

    private let key: Key
    private let defaultValue: T
    private let defaults: UserDefaults

    let publisher: CurrentValueSubject<T, Never>

    var wrappedValue: T {
        get {
            publisher.value
        }
        set {
            publisher.send(newValue)
            defaults.set(try! JSONEncoder().encode(newValue), forKey: key.rawValue)
        }
    }

    init(_ key: Key, defaultValue: T, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
        let existingValue = defaults.data(forKey: key.rawValue).map {
            try! JSONDecoder().decode(T.self, from: $0)
        }
        self.publisher = .init(existingValue ?? defaultValue)
    }

}

extension UserDefault {
    enum Key: String {
        case refinedActions
    }
}
