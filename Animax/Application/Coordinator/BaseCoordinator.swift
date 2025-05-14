//  Created by Илья Беников on 14.05.25.

import UIKit

class BaseCoordinator: CoordinatorProtocol, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {}
}
