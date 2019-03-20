import Result
import RxSwift

typealias DataResponse = Response<Data>
typealias Completion = (Result<DataResponse, APIError>) -> Void

class Provider<Request: RequestType> {
    let plugins: [PluginType]

    init(plugins: [PluginType]) {
        self.plugins = plugins
    }
}

private extension Provider {
    func request(_ request: Request, completion: @escaping Completion) -> Cancellable {
        let urlRequest = request.urlRequest
        let preparedRequest = plugins.reduce(urlRequest) { $1.prepare(request: $0, target: request.target) }

        return perform(urlRequest: preparedRequest, request: request, completion: completion)
    }

    func perform(urlRequest: URLRequest, request: Request, completion: @escaping Completion) -> CancellableToken {
        plugins.forEach { $0.willSend(request: urlRequest, target: request.target) }
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] in
            switch ($0, $1, $2) {
            case let (data, .some(response), .none):
                let response = DataResponse(model: data ?? Data(), statusCode: (response as? HTTPURLResponse)?.statusCode ?? 200)
                completion(.success(response))
                self?.plugins.forEach { $0.didReceive(result: .success(response), target: request.target) }
            case let (_, _, .some(error)):
                let apiError = APIError(error: error)
                completion(.failure(apiError))
                self?.plugins.forEach { $0.didReceive(result: .failure(apiError), target: request.target) }
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
                let apiError = APIError(error: error)
                completion(.failure(apiError))
                self?.plugins.forEach { $0.didReceive(result: .failure(apiError), target: request.target) }
            }
        }
        let preparedTask = plugins.reduce(task) { $1.prepare(task: $0, target: request.target) }
        preparedTask.resume()

        return CancellableToken(task: preparedTask)
    }
}

extension Provider {
    func requestModel<T: Decodable>(request: Request) -> Observable<Response<T>> {
        return Observable<Response<T>>.create { observer in
            let cancellable = self.request(request) { result in
                switch result.tryDecode(T.self) {
                case .success(let model):
                    observer.onNext(model)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create(with: cancellable.cancel)
        }
    }
}

extension Provider {
    func requestEmpty(_ request: Request) -> Observable<Response<Void>> {
        return Observable<Response<Void>>.create { observer in
            let cancellable = self.request(request) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response.map { _ in () })
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create(with: cancellable.cancel)
        }
    }
}
