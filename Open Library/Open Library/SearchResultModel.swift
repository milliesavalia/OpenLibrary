struct SearchResult: Codable {
    let start: Int?
    let count: Int?
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case count = "numFound"
        case books = "docs"
    }
}

struct Book: Codable {
    let title: String
    let author: [String]?
    let publishYear: Int?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case author = "author_name"
        case publishYear = "first_publish_year"
    }
}
