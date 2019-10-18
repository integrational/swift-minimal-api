import Vapor

/// Get a logger service from the given container, if possible.
func log(_ c: Container) -> Logger? {
    try? c.make(Logger.self)
}

/// Asynchronously perform the given work function on the event loop of the given worker, resulting in a future of the given type.
func async<T>(of type: T.Type, on w: Worker, work: @escaping () throws -> T) -> Future<T> {
    let p = w.eventLoop.newPromise(of: type)
    DispatchQueue.global().async {
        do {
            p.succeed(result: try work())
        } catch {
            p.fail(error: error)
        }
    }
    return p.futureResult
}
