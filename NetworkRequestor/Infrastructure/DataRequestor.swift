class DataRequestor {
    private let requestable: Requestable
    private var task: URLSessionTask?
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    deinit {
        task?.cancel()
    }
    
    func requestSomething(from endpoint: String) {
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
                APIMapper<[DummyResponse]>().map(response.0, response.1, completion: { apiMapperResult in
                    switch apiMapperResult {
                    case .success(let dummyResponse):
                        print("sucess: \(dummyResponse)")
                        
                    case .failure(let error):
                        print("error: \(error)")
                    }
                })
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

struct DummyResponse: Decodable {
    var name: String
    var city: String
}
