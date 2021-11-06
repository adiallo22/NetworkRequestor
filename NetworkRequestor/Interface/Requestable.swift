import Foundation

public protocol Requestable {
    typealias ServerResponse = Result<(Data, URLResponse), NetworkError>
    func requestData(
        from networkRequest: NetworkRequest, completion: @escaping (ServerResponse) -> Void
    ) -> URLSessionDataTask?
}
