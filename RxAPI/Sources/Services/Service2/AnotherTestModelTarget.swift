struct AnotherTestModelTarget: Service2Target {
    let path = "/path/to/another/resource"
    let method = HTTPMethod.get
    let task: Task
    let headers: [String : String] = [:]

    init(title: String) {
        task = .requestParameters(parameters: ["title": title], encoding: JSONEncoding.default)
    }
}
