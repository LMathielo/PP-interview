//
//  Network.swift
//  Interview
//
//  Created by Lucas Mathielo on 05/05/26.
//  Copyright © 2026 PicPay. All rights reserved.
//

import Foundation
import UIKit

protocol Network {
    func fetch<T: Decodable>(with apiURL: String) async -> Result<T, Error>
}

final class NetworkImpl: Network {
    private let session: APISession
    
    init(session: APISession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(with apiURL: String) async -> Result<T, Error> {
        guard let api = URL(string: apiURL) else {
            return .failure(APIError.invalidUrl)
        }
        
        guard let (data, response) = try? await session.data(from: api) else {
            return .failure(APIError.apiError)
        }
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            return .failure(APIError.networkError)
        }
        
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            return .failure(APIError.decodingError)
        }
        
        return .success(decoded)
    }
}
