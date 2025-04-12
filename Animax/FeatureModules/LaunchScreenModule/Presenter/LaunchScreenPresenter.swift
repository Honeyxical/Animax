//  Created on 21.03.25

final class LaunchScreenPresenter: BasePresenter
<
LaunchScreenModuleOutput, 
LaunchScreenInteractorInput, 
LaunchScreenRouterInputProtocol,
LaunchScreenViewInput
> {

}

// MARK: Module Input
extension LaunchScreenPresenter: LaunchScreenModuleInput {}

// MARK: View Output
extension LaunchScreenPresenter: LaunchScreenViewOutput {
	func viewDidLoad() {}
    
    func viewWillAppear() {}
}

// MARK: Interactor Output
extension LaunchScreenPresenter: LaunchScreenInteractorOutput {}
