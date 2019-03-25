import Foundation

protocol ParameterEncoding {
    func encode(request: URLRequest, with parameters: [String: Any]) -> URLRequest
}

struct JSONEncoding: ParameterEncoding {
    static let `default` = JSONEncoding()

    func encode(request: URLRequest, with parameters: [String: Any]) -> URLRequest {
        var encodedRequest = request
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            if encodedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                encodedRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            encodedRequest.httpBody = data
        } catch {
            return encodedRequest
        }

        return encodedRequest
    }
}
