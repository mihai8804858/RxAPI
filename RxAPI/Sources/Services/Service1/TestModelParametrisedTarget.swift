struct TestModelParametrisedTarget: Service1Target {
    let path = "/path/to/resource"
    let method = HTTPMethod.get
    let task: Task
    let headers: [String : String] = [:]

    init(id: String) {
        task = .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
    }
}
