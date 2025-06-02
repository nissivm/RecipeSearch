import SwiftUI

struct ErrorView: View {
    let text: String

    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.vertical, 16)
        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
        .padding(.horizontal, 40)
    }
}

#Preview {
    ErrorView(text: "OOps, an error occurred")
}
