import RxSwift

protocol SharedRequest {
    static var requestID: String { get }
}

struct SharedRequestToken<T> {
    let request: SharedRequest.Type
    let observable: Observable<T>
}

final class SharedRequestContainer<T> {
    private var tokens: [SharedRequestToken<T>] = []

    func source(for request: SharedRequest.Type, build: () -> Observable<T>) -> Observable<T> {
        if let shared = tokens.first(where: { $0.request.requestID == request.requestID })?.observable {
            return shared
        } else {
            let sharedSource = build().share()
            sharedSource.always { [weak self] in
                guard let index = self?.tokens.firstIndex(where: { $0.request.requestID == request.requestID }) else { return }
                self?.tokens.remove(at: index)
            }
            tokens.append(SharedRequestToken(request: request, observable: sharedSource))
            return sharedSource
        }
    }
}
