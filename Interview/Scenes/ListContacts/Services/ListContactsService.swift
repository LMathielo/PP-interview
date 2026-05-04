import Foundation

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"

protocol ListContactService {
    func fetchContacts<T: Decodable>() async -> Result<T, Error>
}

class ListContactServiceImpl: ListContactService {
    
    let session: APISession
    
    init(session: APISession = URLSession.shared) {
        self.session = session
    }
    
    func fetchContacts<T: Decodable>() async -> Result<T, Error> {
        guard let api = URL(string: apiURL) else {
            return .failure(APIError.invalidUrl)
        }
        
        guard let (data, response) = try? await session.data(from: api) else {
            return .failure(APIError.apiError)
        }
        
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            return .failure(APIError.decodingError)
        }
        
        return .success(decoded)
    }
}
