import SwiftUI

/// A view modifier that performs an asynchronous task only once when the view appears.
struct OnTaskFirstAppearModifier: ViewModifier {
    private let onTaskFirstAppearAction: () async -> Void

    @State private var hasAppeared = false

    init(_ onTaskFirstAppearAction: @escaping () async -> Void) {
        self.onTaskFirstAppearAction = onTaskFirstAppearAction
    }

    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await onTaskFirstAppearAction()
            }
    }
}
