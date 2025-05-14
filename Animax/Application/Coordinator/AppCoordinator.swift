//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let launchScreenAssembly: LaunchScreenAssembly
    private let onboardingAssembly: OnboardingAssembly
    
    init(
        navigationController: UINavigationController,
        launchScreenAssembly: LaunchScreenAssembly,
        onboardingAssembly: OnboardingAssembly
    ) {
        self.launchScreenAssembly = launchScreenAssembly
        self.onboardingAssembly = onboardingAssembly
        
        super.init(navigationController: navigationController)
    }
    
    override func start(animated: Bool) {
        let module = launchScreenAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

extension AppCoordinator: LaunchScreenModuleOutput, LaunchScreenRoutingHandlingProtocol {
    func performRouteToOnboarding() {
        let module = onboardingAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

extension AppCoordinator: OnboardingModuleOutput, OnboardingRoutingHandlingProtocol {}
