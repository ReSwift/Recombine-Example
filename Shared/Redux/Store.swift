import Recombine
import Foundation

typealias Store = BaseStore<Redux.State, Redux.Action.Raw, Redux.Action.Refined>
typealias SubStore<SubState: Equatable, SubAction> = LensedStore<Redux.State, SubState, Redux.Action.Raw, Redux.Action.Refined, SubAction>

extension Redux {
    static let store = Store(
        state: .init(counter: 0),
        stateEquality: ==,
        reducer: Reducer.main,
        middleware: middleware,
        publishOn: RunLoop.main
    )
}
