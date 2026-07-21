import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
    }

    private func styleTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.Others.white

        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.Grayscale.gray500,
            .font: Typography.Body.Regular.xSmall as Any
        ]
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.Primary.primary,
            .font: Typography.Body.Semibold.xSmall as Any
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = Colors.Grayscale.gray500
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.Primary.primary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
