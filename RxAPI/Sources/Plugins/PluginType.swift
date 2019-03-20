import Result

protocol PluginType {
    func prepare(request: URLRequest, target: TargetType) -> URLRequest
    func prepare(task: URLSessionTask, target: TargetType) -> URLSessionTask
    func willSend(request: URLRequest, target: TargetType)
    func didReceive(result: Result<DataResponse, APIError>, target: TargetType)
}

extension PluginType {
    func prepare(request: URLRequest, target: TargetType) -> URLRequest { return request }
    func prepare(task: URLSessionTask, target: TargetType) -> URLSessionTask { return task }
    func willSend(request: URLRequest, target: TargetType) {}
    func didReceive(result: Result<DataResponse, APIError>, target: TargetType) {}
}
