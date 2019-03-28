//
//  PDMovieMetaData.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

public struct PDMovieMetaData: Decodable {
    internal let identifier: String
    public let description: String
    public let credits: String?
    public let directorName: String?
    public let runTime: String?
    public var thumbnailURL: URL? {
        return URL(string: "https://archive.org/download/\(identifier)/__ia_thumb.jpg")
    }
    internal enum CodingKeys: String, CodingKey {
        case identifier, description, credits, runTime = "runtime", directorName = "director"
    }
}

struct PDMovieMetaDataResponse: Decodable {
    let data: PDMovieMetaData
    enum CodingKeys: String, CodingKey {
        case data = "metadata"
    }
}
