//
//  Session.swift
//  Interview
//
//  Created by Lucas Mathielo on 03/05/26.
//  Copyright © 2026 PicPay. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case apiError
    case decodingError
}

protocol APISession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: APISession {}
