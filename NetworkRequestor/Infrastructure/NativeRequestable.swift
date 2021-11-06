import Foundation

public class NativeRequestable: Requestable {
    private let sessionConfiguration: URLSessionConfiguration
    private let sessionDelegate: URLSessionDelegate?
    private let operationQueue: OperationQueue?
    private var task: URLSessionDataTask?
    
    public init(
        sessionConfiguration: URLSessionConfiguration = .default,
        sessionDelegate: URLSessionDelegate? = nil,
        operationQueue: OperationQueue? = nil
    ) {
        self.sessionConfiguration = sessionConfiguration
        self.sessionDelegate = sessionDelegate
        self.operationQueue = operationQueue
    }
    
    @discardableResult
    public func requestData(
        from networkRequest: NetworkRequest,
        completion: @escaping (ServerResponse) -> Void
    ) -> URLSessionDataTask? {
        
        guard let url = URL(string: networkRequest.endpoint) else {
            completion(.failure(.wrongURL))
            return task
        }
        
        let session = URLSession(
            configuration: sessionConfiguration,
            delegate: sessionDelegate,
            delegateQueue: operationQueue
        )
        
        task = session.dataTask(
            with: networkRequest.buildURLRequest(from: url)
        ) { data, response, error in
            
            if error != nil  {
                completion(.failure(.dataTaskError))
            }
            
            guard let serverResponse = response as? HTTPURLResponse,
                  serverResponse.statusCode == 200 else {
                completion(.failure(.serverResponseFailure))
                return
            }
            
            guard let unwrappedData = data else {
                completion(.failure(.noDataReceived))
                return
            }
            
            completion(.success((unwrappedData, serverResponse)))
        }
        
        task?.resume()
        return task
    }
}
