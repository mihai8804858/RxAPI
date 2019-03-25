import Nimble
import XCTest
@testable import RxAPI

final class RxAPITests: XCTestCase {
    func testCanGetResource() {
        waitUntil(timeout: 10) { terminate in
            let api = API()
            api.getResource().assert(status: 200, terminate: terminate)
        }
    }

    func testCanGetAnotherResource() {
        waitUntil(timeout: 10) { terminate in
            let api = API()
            api.getAnotherResource(withID: "id").assert(status: 200, terminate: terminate)
        }
    }

    func testCanPostResource() {
        waitUntil(timeout: 10) { terminate in
            let api = API()
            api.postResource("resource").assert(status: 204, terminate: terminate)
        }
    }

    func testCanNotGetResourceWithSpecificID() {
        waitUntil(timeout: 10) { terminate in
            let api = API()
            api.getResource(withID: "__undefined__").assert(errorStatus: 404, terminate: terminate)
        }
    }
}
