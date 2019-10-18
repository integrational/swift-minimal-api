import Vapor

/// Get a logger service from the given container, if possible.
func log(_ c: Container) -> Logger? {
    try? c.make(Logger.self)
}

/// Asynchronously execute the given work function on a thread from the global dispatch queue
/// and return a future of the given type containing the return value of the work function.
/// The future is created on the given worker's event loop.
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
