import Foundation

struct WatchlistItem: Codable, Equatable {
    let id: Int
    let title: String
    let imageURL: String?
    let score: String
    let genres: String
}

protocol WatchlistServiceProtocol: AnyObject {
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(_ item: WatchlistItem)
    func getFavorites() -> [WatchlistItem]
    func favoritesCount() -> Int
}

final class WatchlistService: WatchlistServiceProtocol {
    static let shared = WatchlistService()
    private init() {}

    private let favoritesKey = "animax_favorites"
    private let defaults = UserDefaults.standard

    func isFavorite(id: Int) -> Bool {
        getFavorites().contains(where: { $0.id == id })
    }

    func toggleFavorite(_ item: WatchlistItem) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
        } else {
            favorites.insert(item, at: 0)
        }
        save(favorites, forKey: favoritesKey)
    }

    func getFavorites() -> [WatchlistItem] {
        load(forKey: favoritesKey)
    }

    func favoritesCount() -> Int {
        getFavorites().count
    }

    private func save(_ items: [WatchlistItem], forKey key: String) {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: key)
        }
    }

    private func load(forKey key: String) -> [WatchlistItem] {
        guard let data = defaults.data(forKey: key),
              let items = try? JSONDecoder().decode([WatchlistItem].self, from: data) else {
            return []
        }
        return items
    }
}
