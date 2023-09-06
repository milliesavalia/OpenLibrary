import XCTest
@testable import Open_Library

private func loadBundleData(
    forResource resource: String,
    ofType type: String
) throws -> Data? {
    try Bundle.main.path(forResource: resource, ofType: type)
        .map(URL.init(fileURLWithPath:))
        .map { try Data(contentsOf: $0) }
}

final class MockSearchService: SearchServiceProtocol {
    func requestSearch(input: String) async throws -> Open_Library.SearchResult {
        return try await withCheckedThrowingContinuation { continuation in
            load(completion: continuation.resume(with:))
        }
    }
    
    func load(completion: @escaping (Result<SearchResult, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            switch try? loadBundleData(forResource: "Response", ofType: "json") {
            case let .some(data):
                let decoder = JSONDecoder()
                if let jsonData = try? decoder.decode(SearchResult.self, from: data) {
                    return completion(.success(jsonData))
                } else {
                    return completion(.failure(JsonParsingError()))
                }
            case .none:
                completion(.failure(LoadingError()))
            }
        }
    }
}

final class SearchServiceSpec: XCTestCase {
    let service: SearchServiceProtocol = MockSearchService()
    
    func testLoad() {
        Task {
            let jsonData = try await service.requestSearch(input: "")
            XCTAssert(jsonData.count == 3)
            XCTAssert(jsonData.books.first?.title == "The Giver")
            XCTAssert(jsonData.books.first?.publishYear == 1993)
        }
    }
}
