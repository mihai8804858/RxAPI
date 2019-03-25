public struct TestModel: Decodable {
    public let title: String

    enum CodingKeys: CodingKey {
        case title
    }
}
