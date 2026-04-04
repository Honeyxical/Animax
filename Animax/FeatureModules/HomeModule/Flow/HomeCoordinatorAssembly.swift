//  Created by Илья Беников on 22.11.25.

import UIKit

final class HomeCoordinatorAssembly {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func build() -> BaseCoordinator {
        HomeCoordinator(
            homeAssembly: HomeAssembly(),
            navigationController: navigationController
        )
    }
}
