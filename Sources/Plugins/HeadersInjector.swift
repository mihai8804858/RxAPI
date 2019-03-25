import Foundation

extension URLRequest {
    func addingIfMissing(headers: [String: String]) -> URLRequest {
        var request = self
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        return request
    }

    func addingOrReplacing(headers: [String: String]) -> URLRequest {
        var request = self
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        return request
    }
}

struct HeadersInjector: PluginType {
    enum Strategy {
        case append
        case set
    }

    let strategy: Strategy
    let headers: [String: String]

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        switch strategy {
        case .append:
            return request.addingIfMissing(headers: headers)
        case .set:
            return request.addingOrReplacing(headers: headers)
        }
    }
}

extension HeadersInjector {
    static let defaultHeaders = HeadersInjector(strategy: .append, headers: defaultHTTPHeaders)

    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    static let defaultHTTPHeaders: [String: String] = {
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    private static let unknown = "Unknown"
    private static let bundleVersionKey = "CFBundleShortVersionString"
    private static let libraryName = "RxAPI"

    private static var acceptEncoding: String {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        return "gzip;q=1.0, compress;q=0.5"
    }

    private static var acceptLanguage: String {
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        return Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
    }

    private static var userAgent: String {
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        guard let info = Bundle.main.infoDictionary else { return libraryName }
        let executable = info[kCFBundleExecutableKey as String] as? String ?? unknown
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? unknown
        let appVersion = info[bundleVersionKey] as? String ?? unknown
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? unknown
        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName: String = {
                #if os(iOS)
                return "iOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "macOS"
                #else
                return unknown
                #endif
            }()

            return "\(osName) \(versionString)"
        }()
        let libraryVersion: String = {
            guard let afInfo = Bundle(for: API.self).infoDictionary,
                let build = afInfo[bundleVersionKey] else { return unknown }
            return "\(libraryName)/\(build)"
        }()

        return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(libraryVersion)"
    }
}

