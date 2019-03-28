//
//  PDMovie.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

public struct PDMovie: Decodable {
    internal let identifier: String
    public let title: String
    public let description: String
    public let rating: Double
    public var watchURL: URL? {
        return URL(string: "https://archive.org/download/\(identifier)/format=h.264")
    }
    internal enum CodingKeys: String, CodingKey {
        case identifier, title, description, rating = "avg_rating"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.rating = try Double(container.decodeIfPresent(String.self, forKey: .rating) ?? "0.0") ?? 0.0
    }
    public func metaData(session: URLSession = URLSession.shared,
                         completionQueue: DispatchQueue = DispatchQueue.main,
                         completion: @escaping (PDMovieMetaData?, Error?) -> Void) {
        let endPoint = ArchiveEndPoint.metaData(movie: self)
        session.decodableRequest(with: endPoint) { (response: PDMovieMetaDataResponse?, error) in
            completionQueue.async {
                completion(response?.data, error)
            }
        }
    }
}

internal struct PDMovieResponse: Decodable {
    internal let docs: [PDMovie]
    internal enum CodingKeys: String, CodingKey {
        case response, docs
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        docs = try response.decode([PDMovie].self, forKey: .docs)
    }
}
