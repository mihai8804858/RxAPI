protocol RequestType {
    var baseURL: URL { get }
    var target: TargetType { get }
}

extension URL {
    init<T: RequestType>(request: T) {
        self = request.target.path.isEmpty ?
            request.baseURL :
            request.baseURL.appendingPathComponent(request.target.path)
    }
}

extension URLRequest {
    func encoded(parameters: [String: Any], encoding: ParameterEncoding) -> URLRequest {
        return encoding.encode(request: self, with: parameters)
    }
}

extension RequestType {
    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(request: self))
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        switch target.task {
        case .requestPlain:
            return request
        case let .requestParameters(parameters, encoding):
            return request.encoded(parameters: parameters, encoding: encoding)
        }
    }
}
