import Async
import Service

final class SyncBookService {
    private let booksById = [
        "1": Book(id: "1", title: "Marriage", authors: ["Gerald Loeffler", "Dagmar Loeffler"]),
        "2": Book(id: "2", title: "Birth", authors: ["Adam", "Eva"]),
        "3": Book(id: "3", title: "Death", authors: ["God", "Satan", "The Holy Gost"]),
        "4": Book(id: nil, title: "Unidentified", authors: ["Missing Link"])
    ]
    
    func getAll() throws -> [Book] {
        try maybeThrow(ExpectedError.getAll)
        return booksById.map { $1 }.sorted()
    }
    
    func getById(_ id: String) throws -> Book? {
        try maybeThrow(ExpectedError.getById)
        return booksById[id]
    }
}

final class AsyncBookService {
    private let booksById = [
        "1": Book(id: "1", title: "Marriage", authors: ["Gerald Loeffler", "Dagmar Loeffler"]),
        "2": Book(id: "2", title: "Birth", authors: ["Adam", "Eva"]),
        "3": Book(id: "3", title: "Death", authors: ["God", "Satan", "The Holy Gost"]),
        "4": Book(id: nil, title: "Unidentified", authors: ["Missing Link"])
    ]
    
    func getAll(on w: Worker) -> Future<[Book]> {
        async(of: [Book].self, on: w) {
            try maybeThrow(ExpectedError.getAll)
            return self.booksById.map { $1 }.sorted()
        }
    }
    
    func getById(_ id: String, on w: Worker) -> Future<Book?> {
        async(of: Book?.self, on: w) {
            try maybeThrow(ExpectedError.getById)
            return self.booksById[id]
        }
    }
}

fileprivate enum ExpectedError : Error {
    case getAll
    case getById
}

fileprivate func maybeThrow(_ e: Error) throws {
    if Int64(Date().timeIntervalSince1970 * 1000) % 4 == 0 {
        throw e
    }
}
