import Foundation
import Quick
import Nimble
import XCTest
import NetworkRequestor

class NativeRequestableTests: QuickSpec {
    
    override func spec() {
        
        describe("NativeRequestable") {
            context("when requestData()") {
                it("should return failure when url is wrong") {
                    let sut = makeSUT()
                    let mockNetworkRequest = NetworkRequest(endpoint: "", headers: nil, body: nil, requestedTimeOut: nil, httpMethod: .GET)
                    
                    var receivedError: NetworkError?
                    sut.requestData(from: mockNetworkRequest) { response in
                        switch response {
                        case .success:
                            XCTFail("it should have failed, but received \(response) instead.")
                        case .failure(let error):
                            receivedError = error
                        }
                    }
                    
                    expect(receivedError).to(equal(.wrongURL))
                }
                
                
            }
        }
        
        func makeSUT() -> NativeRequestable {
            return NativeRequestable(sessionConfiguration: .default)
        }
    }
}
