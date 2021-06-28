import SwiftUI
import Recombine

struct CounterView: View {
    @StateObject var store = Redux.store.lensing(
        state: \.counter,
        actions: { .modify($0) }
    )

    var body: some View {
        HStack {
            Button(action: {
                store.dispatch(refined: .decrease)
            }, label: {
                Image(systemName: "minus.circle")
            })
            Text("\(store.state)")
            Button(action: {
                store.dispatch(refined: .increase)
            }, label: {
                Image(systemName: "plus.circle")
            })
        }
    }
}
