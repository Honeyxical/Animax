final class FavoritesRouter: BaseRouter<FavoritesRoutingHandlingProtocol> {}

extension FavoritesRouter: FavoritesRouterInputProtocol {
    func routeToAnimeDetail(id: Int) {
        moduleRoutingHandler?.performRouteToAnimeDetailFromFavorites(id: id)
    }
}
