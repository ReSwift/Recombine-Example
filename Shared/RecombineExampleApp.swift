import SwiftUI
import Recombine
import Combine

@main
struct RecombineExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Redux.store)
                .environmentObject(
                    Redux.store.lensing(
                        state: \.counter,
                        actions: Redux.Action.Refined.modify
                    )
                )
                .environmentObject(
                    Redux.store.lensing(
                        state: \.text,
                        actions: Redux.Action.Refined.setText
                    )
                )
        }
    }
}
