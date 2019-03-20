enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}

protocol TargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: [String: String] { get }
}
