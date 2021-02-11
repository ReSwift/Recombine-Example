import SwiftUI
import Recombine
import Combine

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var counterStore: SubStore<Int, Redux.Action.Refined.Modification>
    @EnvironmentObject var textStore: SubStore<String?, String?>

    static let clearSavedSignal = PassthroughSubject<(), Never>()
    @State var refinedActions: [TimeInterval: [Redux.Action.Refined]] = [:]
    @State var started = Date()
    @State var sliderLocation: Double = 1
    @State var states: [Redux.State] = [Redux.store.state]
    @State var cancellables = Set<AnyCancellable>()
    var statesPublisher: AnyPublisher<Redux.State, Never> {
        return store.refinedActions
            .zip(store.$state.dropFirst())
            .compactMap { action, state in
                switch action {
                case .state:
                    return nil
                default:
                    return state
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func replay(actions: [TimeInterval: [Redux.Action.Refined]]) {
        started = Date()
        actions
            .sorted { $0.key < $1.key }
            .publisher
            .flatMap {
                $0.value.publisher.delay(
                    for: .seconds($0.key - Date().timeIntervalSince(started)),
                    scheduler: RunLoop.main
                )
            }
            .handleEvents(receiveOutput: { value in
                print(value)
            })
            .map(ActionStrata.refined)
            .prefix(untilOutputFrom: Self.clearSavedSignal)
            .subscribe(Redux.store)
    }

    var body: some View {
        VStack {
            if let text = textStore.state {
                Text(text)
            }
            Spacer()
            HStack {
                Button(action: {
                    store.dispatch(refined: .modify(.decrease))
                }, label: {
                    Image(systemName: "minus.circle")
                })
                Text("\(counterStore.state)")
                Button(action: {
                    counterStore.dispatch(refined: .increase)
                }, label: {
                    Image(systemName: "plus.circle")
                })
            }
            Spacer()
            Button("Network request") {
                store.dispatch(raw: .networkCall(URL(string: "https://www.google.com")!))
            }
            Button("Reset") {
                Self.clearSavedSignal.send(())
            }
            Button("Replay Actions") {
                started = Date()
                replay(actions: refinedActions)
            }
            Button("Randomly Set Text") {
                textStore.dispatch(refined: Int.random(in: .min...Int.max).description)
            }
            Button("Load Actions From Disk") {
                UserDefaults.standard.data(forKey: "actions").map {
                    try! JSONDecoder().decode([TimeInterval: [Redux.Action.Refined]].self, from: $0)
                }
                .map(replay(actions:))
            }
            .disabled(UserDefaults.standard.data(forKey: "actions") == nil)

            Slider(value: $sliderLocation, in: 1...Double(max(2, states.count)), step: 1)
                .padding([.leading, .trailing, .bottom])
                .disabled(states.count < 2)
        }
        .onChange(of: sliderLocation) { value in
            store.dispatch(refined: .state(states[Int(round(sliderLocation) - 1)]))
        }
        .onReceive(statesPublisher) {
            states.append($0)
            sliderLocation = .init(states.count)
        }
        .onReceive(
            Redux.store.refinedActions.receive(on: RunLoop.main)
        ) { action in
            switch action {
            case .modify:
                refinedActions[Date().timeIntervalSince(started), default: []].append(action)
                UserDefaults.standard.set(try! JSONEncoder().encode(refinedActions), forKey: "actions")
            default:
                break
            }
        }
        .onReceive(Self.clearSavedSignal) {
            started = Date()
            Redux.store.dispatch(refined: .state(states[0]))
            refinedActions = [:]
            states = .init(states.prefix(1))
        }
    }
}
