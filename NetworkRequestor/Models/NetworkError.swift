public enum NetworkError: Error {
    case wrongURL
    case dataTaskError
    case serverResponseFailure
    case noDataReceived
    case failedParsing
    case not200Response
}
