import Recombine
import Foundation

extension Redux {
    typealias StoreType = Store<State, Action.Raw, Action.Refined>
    static let store = StoreType(
        state: .init(counter: 0),
        reducer: Reducer.main,
        middleware: middleware,
        publishOn: RunLoop.main
    )
}
