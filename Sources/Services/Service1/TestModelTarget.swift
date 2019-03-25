struct TestModelTarget: Service1Target, SharedRequest {
    static let requestID = "com.mseremet.RxAPI.TestModelTarget"

    let path = "/path/to/resource"
    let method = HTTPMethod.get
    let task = Task.requestPlain
    let headers: [String : String] = [:]
}
