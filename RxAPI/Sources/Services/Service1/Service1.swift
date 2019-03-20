import Foundation

protocol Service1Target: TargetType {}

struct Service1: RequestType {
    enum Version: String {
        case v1
        case v2
    }

    private let serviceTarget: Service1Target
    let version: Version

    var baseURL: URL {
        return URL(string: "https://api-base-url/service-1/\(version.rawValue)")!
    }

    var target: TargetType {
        return serviceTarget
    }

    init(_ serviceTarget: Service1Target, version: Version = .v2) {
        self.serviceTarget = serviceTarget
        self.version = version
    }
}

final class Service1Provider: Provider<Service1> {
    let headersPlugin = HeadersInjector.defaultHeaders

    override init(plugins: [PluginType] = []) {
        super.init(plugins: [headersPlugin] + plugins)
    }
}

