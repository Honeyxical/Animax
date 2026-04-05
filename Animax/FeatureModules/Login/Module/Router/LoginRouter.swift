final class LoginRouter: BaseRouter<LoginRoutingHandlingProtocol> {}

extension LoginRouter: LoginRouterInputProtocol {
    func routeToHome() {
        moduleRoutingHandler?.performRouteToHome()
    }

    func routeToSignUp() {
        let signUpVC = SignUpViewController()
        signUpVC.onSignUpSuccess = { [weak self] in
            self?.moduleRoutingHandler?.performRouteToHome()
        }
        viewController.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
