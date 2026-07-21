final class ProfileRouter: BaseRouter<ProfileRoutingHandlingProtocol> {}

extension ProfileRouter: ProfileRouterInputProtocol {
    func routeToOnboarding() {
        moduleRoutingHandler?.performLogout()
    }
}
