import RxSwift
import XCTest
@testable import RxAPI

extension ObservableType where E: StatusCodeContaining {
    func assert(status: Int, terminate: @escaping () -> Void) {
        onSuccess { response in
            XCTAssertEqual(response.statusCode, status)
        }.onFailure { error in
            XCTFail(error.localizedDescription)
        }.always(terminate).run()
    }

    func assert(errorStatus: Int, terminate: @escaping () -> Void) {
        onSuccess { value in
            XCTFail("Expected to fail, but succeeded with \(value)")
        }.onFailure { error in
            XCTAssertEqual((error as? APIError)?.code, errorStatus)
        }.always(terminate).run()
    }
}
