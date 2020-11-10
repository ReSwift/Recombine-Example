import Recombine

extension Redux {
    enum Reducer {
        static let main = MutatingReducer<State, Action.Refined> { state, action in
            switch action {
            case let .state(s):
                state = s
            case let .modify(action):
                state.counter = modification(state: state.counter, action: action)
            case let .setText(text):
                state.text = text
            }
        }

        static let modification = PureReducer<Int, Action.Refined.Modification> { state, action in
            switch action {
            case .increase:
                return state + 1
            case .decrease:
                return state - 1
            case let .set(value):
                return value
            }
        }
    }
}
