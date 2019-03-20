enum APIError: Error {
    case underlaying(Error)

    init(error: Error) {
        self = .underlaying(error)
    }
}
