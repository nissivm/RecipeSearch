import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    @StateObject private var coordinator = AppCoordinator.shared

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            )
            .navigationBarTitleDisplayMode(.inline)
    }
}
