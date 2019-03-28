//
//  EndPoint.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

protocol EndPoint {
    var url: URL? { get }
}

enum ArchiveEndPoint: EndPoint {
    case movies(category: PDCategory, page: Int)
    case metaData(movie: PDMovie)
    var url: URL? {
        switch self {
        case let .movies(category, page):
            return URL(string: """
                https://archive.org/advancedsearch.php?\
                q=collection:(feature_films) AND \
                subject:(\(category.tags.joined(separator: " OR "))) \
                AND mediatype:(movies)\
                &fl[]=identifier\
                &fl[]=avg_rating\
                &fl[]=description\
                &fl[]=title\
                &sort[]=downloads desc&sort[]=&sort[]=\
                &rows=50\
                &output=json\
                &page=\(page)
                """.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        case let .metaData(movie):
            return URL(string: "https://archive.org/metadata/\(movie.identifier)")
        }
    }
}
