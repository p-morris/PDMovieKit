//
//  URLSession+Decoding.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

extension URLSession {
    enum Errors {
        static var invalidURL = NSError(
            domain: "URLSesssionErrorDomain",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]
        )
    }
    func decodableRequest<T>(with endPoint: EndPoint,
                             decoder: JSONDecoder = JSONDecoder(),
                             completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        guard  let url = endPoint.url else {
            completion(nil, Errors.invalidURL)
            return
        }
        dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let response = try decoder.decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
