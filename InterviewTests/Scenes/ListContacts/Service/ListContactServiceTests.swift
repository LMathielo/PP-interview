import XCTest
@testable import Interview

class ListContactServiceTests: XCTestCase {
    var sut: ListContactService!
    fileprivate var apiSessionMock: APISessionMock!
        
    override func setUp() {
        apiSessionMock = APISessionMock()
        
        sut = ListContactServiceImpl(session: apiSessionMock)
    }
    
    func test_callJson() async {
        // Given
        let expected: [Contact] = [
            Contact(id: 2, name: "Beyonce", photoURL: "https://api.adorable.io/avatars/285/a2.png")
        ]
        
        // When
        let result: Result<[Contact], Error> = await sut.fetchContacts()
        
        guard case let .success(contacts) = result else {
            XCTFail("not a success")
            return
        }
        
        // Then
        XCTAssertEqual(contacts, expected)
        XCTAssertEqual(apiSessionMock.dataTaskCallsCount, 1)
    }
}

fileprivate class APISessionMock: APISession {
    var dataTaskCallsCount = 0
    
    private let mockData: Data! = {
        """
        [{
          "id": 2,
          "name": "Beyonce",
          "photoURL": "https://api.adorable.io/avatars/285/a2.png"
        }]
        """.data(using: .utf8)
    }()
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        dataTaskCallsCount += 1
        return (mockData, URLResponse.init())
    }
}
