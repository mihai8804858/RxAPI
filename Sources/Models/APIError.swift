import Foundation

enum APIError: Error {
    case underlaying(Error)

    init(error: Error) {
        self = .underlaying(error)
    }

    var code: Int {
        switch self {
        case .underlaying(let error):
            return (error as NSError).code
        }
    }
}
