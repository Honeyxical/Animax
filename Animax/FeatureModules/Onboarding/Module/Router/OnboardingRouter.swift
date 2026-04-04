final class OnboardingRouter: BaseRouter<OnboardingRoutingHandlingProtocol> {}

extension OnboardingRouter: OnboardingRouterInputProtocol {
    func routeToLogin() {
        moduleRoutingHandler?.performRouteToLogin()
    }
}
