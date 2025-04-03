import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let furnitureEntryView = FurnitureEntryView()
        let hostingController = UIHostingController(rootView: furnitureEntryView)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
        return true
    }
}
