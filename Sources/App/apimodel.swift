import Vapor

struct Book : Content, Equatable, Comparable {
    var id: String?
    var title: String
    var authors: [String]
    
    static func < (lhs: Book, rhs: Book) -> Bool {
        lhs.id < rhs.id
    }
}
