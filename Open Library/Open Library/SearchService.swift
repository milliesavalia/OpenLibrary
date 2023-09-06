import Foundation

protocol SearchServiceProtocol {
    func requestSearch(input: String) async throws -> SearchResult
}

final class SearchService: SearchServiceProtocol {
    func requestSearch(input: String) async throws -> SearchResult {
        let searchQuery = input.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "https://openlibrary.org/search.json?title=\(searchQuery)")!
        return try await withCheckedThrowingContinuation { continuation in
            requestData(url: url, completion: continuation.resume(with:))
        }
    }
    
    func requestData(url: URL, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let jsonData = try? decoder.decode(SearchResult.self, from: data) {
                    return completion(.success(jsonData))
                } else {
                    return completion(.failure(JsonParsingError()))
                }
            } else {
                return completion(.failure(LoadingError()))
            }
        }
        task.resume()
    }
}

struct LoadingError: Error {}
struct JsonParsingError: Error {}
