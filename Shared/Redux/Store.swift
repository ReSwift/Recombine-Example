import Recombine
import Foundation

extension Redux {
    static let store = Store<State, Action.Raw, Action.Refined>(
        state: .init(counter: 0),
        reducer: Reducer.main,
        middleware: middleware,
        publishOn: RunLoop.main
    )
}
