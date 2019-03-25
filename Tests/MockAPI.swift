import RxSwift
@testable import RxAPI

final class MockAPI: APIType {
    var getResourceStub: Observable<Response<TestModel>> = .empty()
    func getResource() -> Observable<Response<TestModel>> {
        return getResourceStub
    }

    var getResourceWithIDStub: Observable<Response<TestModel>> = .empty()
    func getResource(withID id: String) -> Observable<Response<TestModel>> {
        return getResourceWithIDStub
    }

    var getAnotherResourceWithIDStub: Observable<Response<AnotherTestModel>> = .empty()
    func getAnotherResource(withID id: String) -> Observable<Response<AnotherTestModel>> {
        return getAnotherResourceWithIDStub
    }

    var postResourceStub: Observable<Response<Void>> = .empty()
    func postResource(_ resource: String) -> Observable<Response<Void>> {
        return postResourceStub
    }
}
