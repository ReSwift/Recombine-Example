import SwiftUI
import Recombine

struct ContentView: View {
    @EnvironmentObject var store: Store<Redux.State, Redux.Action.Raw, Redux.Action.Refined>
    
    var body: some View {
        VStack {
            if let text = store.state.text {
                Text("Error: \(text)")
            }
            Text("\(store.state.counter)")
            HStack {
                Button(action: {
                    store.dispatch(refined: .modify(.decrease))
                }, label: {
                    Image(systemName: "minus.circle")
                })
                Button(action: {
                    store.dispatch(refined: .modify(.increase))
                }, label: {
                    Image(systemName: "plus.circle")
                })
            }
            Button("Network request") {
                store.dispatch(raw: .networkCall(URL(string: "https://www.google.com")!))
            }
            Button("Reset") {
                store.dispatch(raw: .reset)
            }
            Button("Clear Saved Actions") {
                RecombineExampleApp.clearSavedSignal.send(())
            }
        }
    }
}
