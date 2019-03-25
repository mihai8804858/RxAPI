import RxSwift

public protocol APIType {
    func getResource() -> Observable<Response<TestModel>>
    func getResource(withID id: String) -> Observable<Response<TestModel>>
    func getAnotherResource(withID id: String) -> Observable<Response<AnotherTestModel>>
    func postResource(_ resource: String) -> Observable<Response<Void>>
}

public final class API: APIType {
    private let service1Provider = Service1Provider()
    private let service2Provider = Service2Provider()

    let resourceContainer = SharedRequestContainer<Response<TestModel>>()

    public func getResource() -> Observable<Response<TestModel>> {
        return resourceContainer.source(for: TestModelTarget.self) {
            service1Provider.requestModel(request: Service1(TestModelTarget()))
        }
    }

    public func getResource(withID id: String) -> Observable<Response<TestModel>> {
        return service1Provider.requestModel(request: Service1(TestModelParametrisedTarget(id: id)))
    }

    public func getAnotherResource(withID id: String) -> Observable<Response<AnotherTestModel>> {
        return getResource(withID: id).then { response -> Observable<Response<AnotherTestModel>> in
            return self.service2Provider.requestModel(
                request: Service2(AnotherTestModelTarget(title: response.model.title))
            )
        }
    }

    public func postResource(_ resource: String) -> Observable<Response<Void>> {
        return service2Provider.requestEmpty(Service2(PostResourceTarget(resource: resource)))
    }
}
