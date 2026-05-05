import Foundation
import UIKit

protocol ListContactService {
    func fetchContacts() async -> Result<[Contact], Error>
}

class ListContactServiceImpl: ListContactService {
    let network: Network
    
    init(network: Network = NetworkImpl()) {
        self.network = network
    }
    
    func fetchContacts() async -> Result<[Contact], Error> {
        let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"
        return await network.fetch(with: apiURL)
    }
}
