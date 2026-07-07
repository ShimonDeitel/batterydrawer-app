import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Theme.accent)
                    Text("Battery Drawer Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(.white)
                    Text("Unlimited devices, low-stock shopping list, and change-history log")
                        .font(Theme.bodyFont)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal)
                    Text(purchases.product?.displayPrice ?? "2.99 one-time")
                        .font(Theme.headlineFont)
                        .foregroundStyle(Theme.accent2)
                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPro { dismiss() }
                        }
                    } label: {
                        Text("Unlock Pro")
                            .font(Theme.headlineFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("unlockProButton")
                    .padding(.horizontal)

                    Button("Not Now") { dismiss() }
                        .accessibilityIdentifier("paywallDismissButton")
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding()
            }
        }
        .task { await purchases.load() }
    }
}
