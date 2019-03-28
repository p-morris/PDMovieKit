//
//  Category.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

public final class PDCategory: Decodable {
    public let name: String
    public let thumbnailURL: String
    internal let tags: [String]
    internal enum CodingKeys: String, CodingKey {
        case name, thumbnailURL, tags
    }
    enum Errors {
        static var domain = "PDMovieKit"
        static var disk = (code: 0, info: [NSLocalizedDescriptionKey: "Failed to load categories from disk"])
        static var invalidURL = (code: 1, info: [NSLocalizedDescriptionKey: "Invalid URL for category"])
    }
    public static func allCategories(completion: ([PDCategory]?, Error?) -> Void) {
        do {
            let categories = try self.categories()
            completion(categories, nil)
        } catch {
            completion(nil, error)
        }
    }
    static func categories(decoder: JSONDecoder = JSONDecoder(),
                           jsonFileName: String = "categories",
                           bundle: Bundle = Bundle(for: PDCategory.self)) throws -> [PDCategory] {
        guard let url = bundle.url(forResource: jsonFileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let categories = try? decoder.decode([PDCategory].self, from: data) else {
            throw NSError(domain: Errors.domain, code: Errors.disk.code, userInfo: Errors.disk.info)
        }
        return categories
    }
    public func movies(page: Int,
                       session: URLSession = URLSession.shared,
                       completionQueue: DispatchQueue = DispatchQueue.main,
                       completion: @escaping ([PDMovie]?, Error?) -> Void) {
        let endPoint = ArchiveEndPoint.movies(category: self, page: page)
        session.decodableRequest(with: endPoint) { (response: PDMovieResponse?, error) in
            completionQueue.async {
                completion(response?.docs, error)
            }
        }
    }
}
