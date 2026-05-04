import XCTest
@testable import Interview

class ListContactServiceTests: XCTestCase {
    var sut: ListContactService!
    fileprivate var urlSessionMock: ApiUrlSessionMock!
        
    override func setUp() {
        urlSessionMock = ApiUrlSessionMock()
        
        sut = ListContactServiceImpl(urlSession: urlSessionMock)
    }
    
    func test_callJson() {
        // Given
        let expected: [Contact] = [
            Contact(id: 2, name: "Beyonce", photoURL: "https://api.adorable.io/avatars/285/a2.png")
        ]
        
        // When
        sut.fetchContacts(completion: { result in
            
            guard case let .success(contacts) = result else {
                XCTFail("not a success")
                return
            }

            XCTAssertEqual(contacts, expected)
        })
        
        // Then
        XCTAssertEqual(urlSessionMock.dataTaskCallsCount, 1)
    }
}

fileprivate class ApiUrlSessionMock: ApiUrlSession {
    var dataTaskCallsCount = 0
    
    private let mockData: Data? = {
        """
        [{
          "id": 2,
          "name": "Beyonce",
          "photoURL": "https://api.adorable.io/avatars/285/a2.png"
        }]
        """.data(using: .utf8)
    }()
    
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, nil, nil)
        dataTaskCallsCount += 1
        
        return URLSessionDataTask()
    }
}
