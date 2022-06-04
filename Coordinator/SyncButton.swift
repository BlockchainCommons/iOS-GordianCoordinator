import SwiftUI

struct SyncButton: View {
    enum State {
        case stopped
        case syncing
        case error
    }
    
    let action: () async -> Void
    @Binding var state: State
    
    init(action: @escaping () async -> Void, state: Binding<State>) {
        self.action = action
        self._state = state
    }
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Label {
                Text("Sync")
            } icon: {
                ZStack {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .opacity(state == .stopped ? 1 : 0)
                    ProgressView()
                        .opacity(state == .syncing ? 1 : 0)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .opacity(state == .error ? 1 : 0)
                }
                .animation(.default, value: state)
                .symbolRenderingMode(.monochrome)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
