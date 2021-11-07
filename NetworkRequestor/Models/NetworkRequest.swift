public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

public struct NetworkRequest {
    let endpoint: String
    let headers: [String: String]?
    let body: Data?
    let requestedTimeOut: Float?
    let httpMethod: HTTPMethod
    
    public init(
        endpoint: String,
        headers: [String: String]? = nil,
        body: Data? = nil,
        requestedTimeOut: Float? = nil,
        httpMethod: HTTPMethod
    ) {
        self.endpoint = endpoint
        self.headers = headers
        self.body = body
        self.requestedTimeOut = requestedTimeOut
        self.httpMethod = httpMethod
    }
    
    public func buildURLRequest(
        from url: URL,
        cachingPolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    ) -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: cachingPolicy,
            timeoutInterval: Double(requestedTimeOut ?? 10)
        )
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers ?? [:]
        request.httpBody = body
        return request
    }
}
