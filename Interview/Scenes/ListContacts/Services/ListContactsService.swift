import Foundation

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"

protocol ApiUrlSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: ApiUrlSession { }

protocol ListContactService {
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void)
}

class ListContactServiceImpl: ListContactService {
    let urlSession: ApiUrlSession
    
    init(urlSession: ApiUrlSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchContacts<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let api = URL(string: apiURL) else {
            return
        }
        
        let task = urlSession.dataTask(with: api) { (data, response, error) in
            guard let jsonData = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: jsonData)
                
                completion(.success(decoded))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
