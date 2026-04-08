final class HomeRouter: BaseRouter<HomeRoutingHandlingProtocol> {}

extension HomeRouter: HomeRouterInputProtocol {
    func routeToAnimeDetail(id: Int) {
        moduleRoutingHandler?.performRouteToAnimeDetail(id: id)
    }

    func routeToTopHits(items: [AnimeCardViewModel]) {
        moduleRoutingHandler?.performRouteToTopHits(items: items)
    }

    func routeToNewEpisodes(items: [AnimeCardViewModel]) {
        moduleRoutingHandler?.performRouteToNewEpisodes(items: items)
    }

    func routeToSearch() {
        moduleRoutingHandler?.performRouteToSearch()
    }

    func routeToNotifications() {
        moduleRoutingHandler?.performRouteToNotifications()
    }
}
