import Dispatch

protocol Cancellable {
    var isCancelled: Bool { get }
    func cancel()
}

final class CancellableToken: Cancellable {
    private(set) var isCancelled = false
    private let task: URLSessionTask

    init(task: URLSessionTask) {
        self.task = task
    }

    func cancel() {
        if isCancelled { return }
        isCancelled = true
        task.cancel()
    }
}
