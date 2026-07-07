import SwiftUI

@main
struct BatteryDrawerApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .onChange(of: purchases.isPro) { _, newValue in
                    store.isPro = newValue
                }
                .task {
                    store.isPro = purchases.isPro
                }
        }
    }
}
