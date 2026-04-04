import Foundation

protocol AnimeNetworkServiceProtocol {
    func fetchTopAnime(completion: @escaping (Result<[AnimeItem], Error>) -> Void)
    func fetchSeasonalAnime(completion: @escaping (Result<[AnimeItem], Error>) -> Void)
    func fetchAnimeDetail(id: Int, completion: @escaping (Result<AnimeItem, Error>) -> Void)
    func searchAnime(query: String, completion: @escaping (Result<[AnimeItem], Error>) -> Void)
}

final class AnimeNetworkService: AnimeNetworkServiceProtocol {
    private let baseURL = "https://api.jikan.moe/v4"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func fetchTopAnime(completion: @escaping (Result<[AnimeItem], Error>) -> Void) {
        fetch(path: "/top/anime?limit=15", responseType: AnimeListResponse.self) {
            completion($0.map { $0.data })
        }
    }

    func fetchSeasonalAnime(completion: @escaping (Result<[AnimeItem], Error>) -> Void) {
        fetch(path: "/seasons/now?limit=15", responseType: AnimeListResponse.self) {
            completion($0.map { $0.data })
        }
    }

    func fetchAnimeDetail(id: Int, completion: @escaping (Result<AnimeItem, Error>) -> Void) {
        fetch(path: "/anime/\(id)", responseType: AnimeDetailResponse.self) {
            completion($0.map { $0.data })
        }
    }

    func searchAnime(query: String, completion: @escaping (Result<[AnimeItem], Error>) -> Void) {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        fetch(path: "/anime?q=\(encoded)&limit=20", responseType: AnimeListResponse.self) {
            completion($0.map { $0.data })
        }
    }

    private func fetch<T: Decodable>(
        path: String,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        session.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, let self = self else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        }
    }
}
