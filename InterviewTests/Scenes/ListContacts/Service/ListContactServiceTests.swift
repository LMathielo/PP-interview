import XCTest
@testable import Interview

class ListContactServiceTests: XCTestCase {
    var sut: ListContactService!
    fileprivate var networkMock: NetworkMock!
        
    override func setUp() {
        networkMock = NetworkMock()
        
        sut = ListContactServiceImpl(network: networkMock)
    }
    
    func test_callJson() {
        // Given
        let expected: [Contact] = [
            Contact(id: 2, name: "Beyonce", photoURL: "https://api.adorable.io/avatars/285/a2.png")
        ]
        
        networkMock.result = .success(
            [
                Contact(id: 2, name: "Beyonce", photoURL: "https://api.adorable.io/avatars/285/a2.png")
            ]
        )
        
        // When
        sut.fetchContacts(completion: { result in
            
            guard case let .success(contacts) = result else {
                XCTFail("not a success")
                return
            }

            XCTAssertEqual(contacts, expected)
        })
        
        // Then
        XCTAssertEqual(networkMock.fetchCallsCount, 1)
    }
}

fileprivate class NetworkMock: Network {
    var result: Result<[Contact], any Error>!
    var fetchCallsCount = 0
    
    func fetch<T>(with apiURL: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        fetchCallsCount += 1
        completion((result as! Result<T, any Error>))
    }
}
