import Recombine
import Combine
import Foundation

extension Redux {
    static let thunk: Thunk<State, Action.Raw, Action.Refined> = .init { state, action -> AnyPublisher<ActionStrata<Action.Raw, Action.Refined>, Never> in
        switch action {
        case let .networkCall(url):
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .flatMap { data, _ in
                    state.map {
                        .refined(.modify(.set($0.counter + data.count)))
                    }
                }
                .catch { error in
                    Just(.refined(.setText(error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .reset:
            return ThunkFunctions.reset()
        }
    }
    
    enum ThunkFunctions {
        static func reset() -> AnyPublisher<ActionStrata<Action.Raw, Action.Refined>, Never> {
            [
                .modify(.set(0)),
                .setText(nil)
            ]
            .map { .refined($0) }
            .publisher
            .eraseToAnyPublisher()
        }
    }
}
