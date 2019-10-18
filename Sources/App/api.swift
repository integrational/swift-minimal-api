import Vapor

/// Register your application's routes here.
func routes(_ router: Router) throws {
    let syncSvc = SyncBookService()
    /// curl -i http://localhost:8080/sync/books
    router.get("sync", "books") { req -> Future<[Book]> in
        async(of: [Book].self, on: req) {
            log(req)?.info("Received \(req)")
            return try syncSvc.getAll()
        }
    }
    /// curl -i http://localhost:8080/sync/books/1
    router.get("sync", "books", String.parameter) { req -> Future<Book> in
        async(of: Book.self, on: req) {
            log(req)?.info("Received \(req)")
            let id = try req.parameters.next(String.self)
            guard let b = try syncSvc.getById(id) else {
                throw Abort(.badRequest)
            }
            return b
        }
    }
    
    let asyncSvc = AsyncBookService()
    /// curl -i http://localhost:8080/async/books
    router.get("async", "books") { req -> Future<[Book]> in
        log(req)?.info("Received \(req)")
        return asyncSvc.getAll(on: req)
    }
    /// curl -i http://localhost:8080/async/books/1
    router.get("async", "books", String.parameter) { req -> Future<Book> in
        log(req)?.info("Received \(req)")
        let id = try req.parameters.next(String.self)
        return asyncSvc.getById(id, on: req).unwrap(or: Abort(.badRequest))
    }
}
