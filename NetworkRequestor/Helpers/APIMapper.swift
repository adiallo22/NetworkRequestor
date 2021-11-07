class APIMapper<T: Decodable> {

    func map(
        _ data: Data,
        _ response: URLResponse,
        completion: @escaping (Result<(T), NetworkError>) -> Void
    ) {

        guard let serverResponse = response as? HTTPURLResponse,
              serverResponse.statusCode == 200 else {
            completion(.failure(.not200Response))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.failedParsing))
        }
    }
}
