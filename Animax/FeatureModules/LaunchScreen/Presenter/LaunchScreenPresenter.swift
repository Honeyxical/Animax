//  Created on 21.03.25

final class LaunchScreenPresenter: BasePresenter
<
LaunchScreenModuleOutput, 
LaunchScreenInteractorInput, 
LaunchScreenRouterInputProtocol,
LaunchScreenViewInput
> {}

// MARK: Module Input
extension LaunchScreenPresenter: LaunchScreenModuleInput {}

// MARK: View Output
extension LaunchScreenPresenter: LaunchScreenViewOutput {
	func viewDidLoad() {
        interactor.start()
    }
}

// MARK: Interactor Output
extension LaunchScreenPresenter: LaunchScreenInteractorOutput {
    func presentLoadingAnimation() {
        view?.startAnimation()
    }
    
    func presentOnboarding() {
        router.routeToOnboarding()
    }
}
