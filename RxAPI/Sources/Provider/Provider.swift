import Result
import RxSwift

class Provider<Request: RequestType> {
    let plugins: [PluginType]

    init(plugins: [PluginType]) {
        self.plugins = plugins
    }

    func requestData(_ request: Request) -> Observable<Response<Data>> {
        let plugins = self.plugins
        return Observable<Response<Data>>.create { observer in
            let urlRequest = request.urlRequest
            let preparedRequest = plugins.reduce(urlRequest) { $1.prepare(request: $0, target: request.target) }
            plugins.forEach { $0.willSend(request: preparedRequest, target: request.target) }
            let task = URLSession.shared.dataTask(with: urlRequest) {
                switch ($0, $1, $2) {
                case let (data, .some(response), .none):
                    let response = Response(
                        model: data ?? Data(),
                        statusCode: (response as? HTTPURLResponse)?.statusCode ?? 200
                    )
                    plugins.forEach { $0.didReceive(result: .success(response), target: request.target) }
                    observer.onNext(response)
                    observer.onCompleted()
                case let (_, _, .some(error)):
                    let apiError = APIError(error: error)
                    plugins.forEach { $0.didReceive(result: .failure(apiError), target: request.target) }
                    observer.onError(apiError)
                default:
                    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
                    let apiError = APIError(error: error)
                    plugins.forEach { $0.didReceive(result: .failure(apiError), target: request.target) }
                    observer.onError(apiError)
                }
            }
            let preparedTask = plugins.reduce(task) { $1.prepare(task: $0, target: request.target) }
            preparedTask.resume()

            return Disposables.create(with: preparedTask.cancel)
        }
    }

    func requestModel<T: Decodable>(request: Request) -> Observable<Response<T>> {
        return requestData(request).then { dataResponse -> Observable<Response<T>> in
            switch dataResponse.tryDecode(T.self) {
            case .success(let model):
                return .just(model)
            case .failure(let error):
                return .error(error)
            }
        }
    }

    func requestEmpty(_ request: Request) -> Observable<Response<Void>> {
        return requestData(request).map { $0.map { _ in () } }
    }
}
