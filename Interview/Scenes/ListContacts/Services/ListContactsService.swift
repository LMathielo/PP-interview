import Foundation

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"

protocol ListContactService {
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void)
}

class ListContactServiceImpl: ListContactService {
    
    let network: Network
    
    init(network: Network = NetworkImpl()) {
        self.network = network
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        // No need to detach in an async thread here, as the completion will be executed in the asynchronous thread after data fetching (network layer)
        network.fetch(with: apiURL, completion: completion)
    }
}
