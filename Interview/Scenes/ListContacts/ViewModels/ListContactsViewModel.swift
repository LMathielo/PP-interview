import Foundation
import UIKit

protocol ListContactsViewModel {
    typealias State = ListContactsViewModelImpl.State
    
    var stateStream: AsyncStream<State> { get }
    func loadContacts() async
    func loadImage(for contact: Contact) async -> UIImage
}

extension ListContactsViewModelImpl {
    enum State {
        case loading
        case success([Contact])
        case error(Error)
    }
}

class ListContactsViewModelImpl: ListContactsViewModel {
    private let service: ListContactService
    private var contacts: [Contact] = []
    var (stateStream, stateContinuation) = AsyncStream<State>.makeStream()
    
    init(service: ListContactService = ListContactServiceImpl()) {
        self.service = service
    }
    
    func loadContacts() async {
        stateContinuation.yield(.loading)
        
        let result: Result<[Contact], Error> = await service.fetchContacts()
        
        switch result {
        case .success(let contacts):
            
            var seenContacts: [String: Int] = [:]
            
            let filteredContatcs = contacts.filter( { contact in
                if seenContacts[contact.name] == nil {
                    seenContacts[contact.name] = contact.id
                    return true
                } else {
                    return false
                }
            })
            
            self.stateContinuation.yield(.success(filteredContatcs))
        case .failure(let error):
            self.stateContinuation.yield(.error(error))
        }
    }
    
    func loadImage(for contact: Contact) async -> UIImage {
        guard
            let urlPhoto = URL(string: contact.photoURL),
            let data = try? Data(contentsOf: urlPhoto),
            let image = UIImage(data: data)
        else {
            return UIImage()
        }
        
        return image
    }
}
