public struct AnotherTestModel: Decodable {
    public let title: String

    enum CodingKeys: CodingKey {
        case title
    }
}
