//
//  APIError.swift
//  Interview
//
//  Created by Lucas Mathielo on 04/05/26.
//  Copyright © 2026 PicPay. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case networkError
    case corruptedData
    case decodingError
}
