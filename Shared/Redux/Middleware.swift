import Recombine
import Combine
import Foundation

extension Redux {
    static let middleware: Middleware<State, Action.Raw, Action.Refined> = Middleware { state, action -> AnyPublisher<Action.Refined, Never> in
        switch action {
        case let .networkCall(url):
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .flatMap { data, _ in
                    state.map {
                        .modify(.set($0.counter + data.count))
                    }
                }
                .catch { error in
                    Just(.setText(error.localizedDescription))
                }
                .eraseToAnyPublisher()
        case .reset:
            return [
                .modify(.set(0)),
                .setText(nil)
            ]
            .publisher
            .eraseToAnyPublisher()
        }
    }
}
