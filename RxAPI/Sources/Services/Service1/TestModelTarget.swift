struct TestModelTarget: Service1Target {
    let path = "/path/to/resource"
    let method = HTTPMethod.get
    let task = Task.requestPlain
    let headers: [String : String] = [:]
}
