//  Created by Илья Беников on 22.11.25.

import UIKit

final class HomeCoordinator: BaseCoordinator {
    let homeAssembly: HomeAssembly
    
    init(homeAssembly: HomeAssembly, navigationController: UINavigationController) {
        self.homeAssembly = homeAssembly
        super.init(navigationController: navigationController)
    }
    
    override func start(animated: Bool) {
        let module = homeAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: animated)
    }
}

extension HomeCoordinator: HomeModuleOutput, HomeRoutingHandlingProtocol {}
