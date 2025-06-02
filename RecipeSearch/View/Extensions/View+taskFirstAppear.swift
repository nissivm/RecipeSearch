import SwiftUI

extension View {
    func taskFirstAppear(_ onTaskFirstAppearAction: @escaping () async -> Void) -> some View {
        modifier(OnTaskFirstAppearModifier(onTaskFirstAppearAction))
    }
}
