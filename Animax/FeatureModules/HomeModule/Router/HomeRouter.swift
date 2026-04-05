final class HomeRouter: BaseRouter<HomeRoutingHandlingProtocol> {}

extension HomeRouter: HomeRouterInputProtocol {
    func routeToAnimeDetail(id: Int) {
        moduleRoutingHandler?.performRouteToAnimeDetail(id: id)
    }
}
