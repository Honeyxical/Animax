import UIKit

final class ProfilePresenter: BasePresenter<
    ProfileModuleOutput,
    ProfileInteractorInput,
    ProfileRouterInputProtocol,
    ProfileViewInput
> {}

// MARK: Module Input
extension ProfilePresenter: ProfileModuleInput {}

// MARK: View Output
extension ProfilePresenter: ProfileViewOutput {
    func viewWillAppear() {
        interactor.loadProfile()
    }

    func didTapLogout() {
        interactor.logout()
    }
}

// MARK: Interactor Output
extension ProfilePresenter: ProfileInteractorOutput {
    func presentProfile(_ viewModel: ProfileViewModel) {
        view?.showProfile(viewModel)
    }

    func performLogout() {
        router.routeToOnboarding()
    }
}
