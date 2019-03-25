import Foundation
import Result

extension Response where Model == Data {
    func tryDecode<D: Decodable>(_ type: D.Type) -> Result<Response<D>, APIError> {
        do {
            let decoded = try JSONDecoder().decode(D.self, from: model)
            return .success(map { _ in decoded })
        } catch let error {
            return .failure(APIError(error: error))
        }
    }
}

extension Result where Value == Response<Data>, Error == APIError {
    func tryDecode<D: Decodable>(_ type: D.Type) -> Result<Response<D>, APIError> {
        return flatMap { $0.tryDecode(type) }
    }
}
