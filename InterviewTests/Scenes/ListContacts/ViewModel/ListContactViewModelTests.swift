import XCTest
@testable import Interview

class ListContactViewModelTests: XCTestCase {
    var sut: ListContactsViewModel!
    fileprivate var serviceMock: ListContactServiceMock!
    
    override func setUp() {
        sut = ListContactsViewModelImpl(
            service: serviceMock
        )
    }
    
    func test_success_empty() {
        // Given
        serviceMock.state = .success([])
        
        sut.updateState = { state in
            guard case let .success(contacts) = state else {
                XCTFail("Expected success state, got \(state)")
                return
            }
            
            XCTAssertEqual(contacts, [])
        }
        
        // When
        sut.loadContacts()
        
        // Then
        
        XCTAssertEqual(serviceMock.completionCallCount, 1)
    }
    
    func test_success_list() {
        // Given
        serviceMock.state = .success([
            Contact(id: 1, name: "test 1", photoURL: "1"),
            Contact(id: 2, name: "test 2", photoURL: "2")
        ])
        
        // When
        // Then
    }
    
    func test_failure() {
        
    }
}

fileprivate class ListContactServiceMock: ListContactService {
    var state: Result<[Interview.Contact], Error>!
    var completionCallCount = 0
    
    func fetchContacts(completion: @escaping (Result<[Interview.Contact], any Error>) -> Void) {
        completionCallCount += 1
        completion(state)
    }
}
