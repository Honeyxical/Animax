import Foundation

struct AnimeListResponse: Decodable {
    let data: [AnimeItem]
}

struct AnimeDetailResponse: Decodable {
    let data: AnimeItem
}

struct AnimeItem: Decodable {
    let malId: Int
    let title: String
    let titleEnglish: String?
    let synopsis: String?
    let score: Double?
    let episodes: Int?
    let status: String?
    let genres: [AnimeGenre]
    let images: AnimeImages
    let rating: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title
        case titleEnglish = "title_english"
        case synopsis, score, episodes, status, genres, images, rating, type
    }
}

struct AnimeImages: Decodable {
    let jpg: AnimeImageURLs
}

struct AnimeImageURLs: Decodable {
    let imageUrl: String?
    let largeImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case largeImageUrl = "large_image_url"
    }
}

struct AnimeGenre: Decodable {
    let malId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case name
    }
}
