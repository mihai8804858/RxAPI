import Foundation

protocol Service2Target: TargetType {}

struct Service2: RequestType {
    private let serviceTarget: Service2Target

    let baseURL = URL(string: "https://api-base-url/service-2/")!

    var target: TargetType {
        return serviceTarget
    }

    init(_ serviceTarget: Service2Target) {
        self.serviceTarget = serviceTarget
    }
}

final class Service2Provider: Provider<Service2> {
    let headersPlugin = HeadersInjector.defaultHeaders

    override init(plugins: [PluginType] = []) {
        super.init(plugins: [headersPlugin] + plugins)
    }
}

