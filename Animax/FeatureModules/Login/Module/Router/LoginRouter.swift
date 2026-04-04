final class LoginRouter: BaseRouter<LoginRoutingHandlingProtocol> {}

extension LoginRouter: LoginRouterInputProtocol {
    func routeToHome() {
        moduleRoutingHandler?.performRouteToHome()
    }
}
