import RxSwift

extension ObservableType {
    @discardableResult
    public func onSuccess(_ block: @escaping (E) -> Void) -> Observable<E> {
        return self.do(onNext: block)
    }

    @discardableResult
    public func onFailure(_ block: @escaping (Error) -> Void) -> Observable<E> {
        return self.do(onError: block)
    }

    @discardableResult
    public func always(_ block: @escaping () -> Void) -> Observable<E> {
        return self.do(onDispose: block)
    }

    @discardableResult
    public func then<O>(_ block: @escaping (E) throws -> O) -> Observable<O.E> where O: ObservableConvertibleType {
        return flatMapLatest(block)
    }

    @discardableResult
    public func run(
        onNext: ((E) -> Swift.Void)? = nil,
        onError: ((Error) -> Swift.Void)? = nil,
        onCompleted: (() -> Swift.Void)? = nil,
        onDisposed: (() -> Swift.Void)? = nil
    ) -> Disposable {
        return subscribe(onNext: onNext, onError: onError, onCompleted: onCompleted, onDisposed: onDisposed)
    }
}
