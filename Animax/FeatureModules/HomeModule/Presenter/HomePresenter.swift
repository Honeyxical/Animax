//  Created on 22.11.25

final class HomePresenter: BasePresenter
<
HomeModuleOutput, 
HomeInteractorInput, 
HomeRouterInputProtocol,
HomeViewInput
> {}

// MARK: Module Input
extension HomePresenter: HomeModuleInput {}

// MARK: View Output
extension HomePresenter: HomeViewOutput {
	func viewDidLoad() {} 
}

// MARK: Interactor Output
extension HomePresenter: HomeInteractorOutput {}