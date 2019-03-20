import Foundation

protocol StatusCodeContaining {
    var statusCode: Int { get }
}

public struct Response<Model>: StatusCodeContaining {
    public let model: Model
    public let statusCode: Int

    public init(model: Model, statusCode: Int) {
        self.model = model
        self.statusCode = statusCode
    }

    func map<U>(_ transform: (Model) -> U) -> Response<U> {
        return Response<U>(model: transform(model), statusCode: statusCode)
    }
}

extension Response: Equatable where Model: Equatable {
    public static func == (lhs: Response<Model>, rhs: Response<Model>) -> Bool {
        return lhs.model == rhs.model && lhs.statusCode == rhs.statusCode
    }
}
