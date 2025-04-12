//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: CoordinatorProtocol, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    private let launchScreenAssembly: LaunchScreenAssembly
    
    init(navigationController: UINavigationController, launchScreenAssembly: LaunchScreenAssembly) {
        self.navigationController = navigationController
        self.launchScreenAssembly = launchScreenAssembly
    }
    
    func start(animated: Bool) {
        let module = launchScreenAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

extension AppCoordinator: LaunchScreenModuleOutput, LaunchScreenRoutingHandlingProtocol {}
