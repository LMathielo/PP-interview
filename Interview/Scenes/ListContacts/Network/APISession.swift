//
//  APISession.swift
//  Interview
//
//  Created by Lucas Mathielo on 04/05/26.
//  Copyright © 2026 PicPay. All rights reserved.
//

import Foundation

protocol APISession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: APISession { }
