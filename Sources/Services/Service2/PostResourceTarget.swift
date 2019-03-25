struct PostResourceTarget: Service2Target {
    let path = "/path/to/post/resource"
    let method = HTTPMethod.post
    let task: Task
    let headers: [String : String] = [:]

    init(resource: String) {
        task = .requestParameters(parameters: ["resource": resource], encoding: JSONEncoding.default)
    }
}
