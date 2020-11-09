import SwiftUI
import Recombine
import Combine

@main
struct RecombineExampleApp: App {
    static let clearSavedSignal = PassthroughSubject<(), Never>()
    @UserDefault(.refinedActions, defaultValue: [:]) static var refinedActions: [TimeInterval: Redux.Action.Refined]
    let started = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Redux.store)
                .onAppear {
                    Self.refinedActions
                        .sorted { $0.key < $1.key }
                        .publisher
                        .prefix(untilOutputFrom: Self.clearSavedSignal)
                        .flatMap {
                            Just($0.value).delay(
                                for: .seconds($0.key - Date().timeIntervalSince(started)),
                                scheduler: RunLoop.main
                            )
                        }
                        .map(ActionStrata.refined)
                        .receive(subscriber: Redux.store)
                }
                .onReceive(Redux.store.refinedActions.dropFirst(Self.refinedActions.count)) { action in
                    Self.refinedActions[Date().timeIntervalSince(started)] = action
                }
                .onReceive(Self.clearSavedSignal) {
                    Self.refinedActions = [:]
                }
        }
    }
}
