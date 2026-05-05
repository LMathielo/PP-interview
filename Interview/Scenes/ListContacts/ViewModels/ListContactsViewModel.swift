import Foundation

protocol ListContactsViewModel {
    typealias State = ListContactsViewModelImpl.State
    var updateState: ((State) -> Void)? { get set }
    
    func loadContacts()
}

class ListContactsViewModelImpl: ListContactsViewModel {
    var updateState: ((State) -> Void)?
    
    enum State {
        case loading
        case success([Contact])
        case error(Error)
    }
    
    private let service: ListContactService
    
    init(service: ListContactService = ListContactServiceImpl()) {
        self.service = service
    }
    
    func loadContacts() {
        updateState?(.loading)
        
        service.fetchContacts { [updateState] result in
            switch result {
            case .success(let contacts):
                updateState?(.success(contacts))
            case .failure(let error):
                updateState?(.error(error))
            }
        }
    }
}
