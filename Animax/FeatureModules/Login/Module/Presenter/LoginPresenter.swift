import UIKit

final class LoginPresenter: BasePresenter<
    LoginModuleOutput,
    LoginInteractorInput,
    LoginRouterInputProtocol,
    LoginViewInput
> {}

// MARK: Module Input
extension LoginPresenter: LoginModuleInput {}

// MARK: View Output
extension LoginPresenter: LoginViewOutput {
    func viewDidLoad() {}

    func didTapLogin(email: String?, password: String?) {
        view?.setLoading(true)
        interactor.login(email: email ?? "", password: password ?? "")
    }

    func didTapSignUp() {
        router.routeToSignUp()
    }
}

// MARK: Interactor Output
extension LoginPresenter: LoginInteractorOutput {
    func loginDidSucceed() {
        view?.setLoading(false)
        router.routeToHome()
    }

    func loginDidFail(message: String) {
        view?.setLoading(false)
        view?.showError(message)
    }
}
