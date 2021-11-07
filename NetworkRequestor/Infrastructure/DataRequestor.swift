class DataRequestor {
    private let requestable: Requestable
    private var task: URLSessionTask?
    
    typealias DataRequestorResult = Result<([DummyResponse]), NetworkError>
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    deinit {
        task?.cancel()
    }
    
    func requestSomething(
        from endpoint: String,
        completion: @escaping (DataRequestorResult) -> Void
    ) {
        
        let request = NetworkRequest(
            endpoint: endpoint,
            headers: nil,
            body: nil,
            requestedTimeOut: nil,
            httpMethod: .GET
        )
        
        task = requestable.requestData(from: request) { result in
            switch result {
            case .success(let response):
                APIMapper<[DummyResponse]>().map(response.0, response.1, completion: completion)
            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct DummyResponse: Decodable {
    var name: String
    var city: String
}
