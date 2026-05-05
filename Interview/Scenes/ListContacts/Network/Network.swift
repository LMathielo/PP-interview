//
//  Network.swift
//  Interview
//
//  Created by Lucas Mathielo on 04/05/26.
//  Copyright © 2026 PicPay. All rights reserved.
//

import Foundation

protocol Network {
    func fetch<T: Decodable>(with apiURL: String, completion: @escaping (Result<T, Error>) -> Void)
}

struct NetworkImpl: Network {
    let urlSession: APISession
    
    init(urlSession: APISession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(with apiURL: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let api = URL(string: apiURL) else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let task = urlSession.dataTask(with: api) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.networkError))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(APIError.corruptedData))
                return
            }

            let decoder = JSONDecoder()
            guard let decoded = try? decoder.decode(T.self, from: jsonData) else {
                completion(.failure(APIError.decodingError))
                return
            }
            
            completion(.success(decoded))
            
//            do {
//                let decoder = JSONDecoder()
//                let decoded = try decoder.decode(T.self, from: jsonData)
//                
//                completion(.success(decoded))
//            } catch let error {
//                completion(.failure(error))
//            }
        }
        
        task.resume()
    }
}
