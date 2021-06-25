import SwiftUI
import Recombine

struct CounterView: View {
    @EnvironmentObject var store: SubStore<Int, Redux.Action.Refined.Modification>

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

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
//            .environmentObject(
//                PreviewStore(
//                    state: .init(counter: 1100)
//                ).lensing(
//                    state: \.counter,
//                    actions: { .modify($0) }
//                )
//            )
    }
}
