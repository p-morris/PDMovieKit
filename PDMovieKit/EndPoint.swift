//
//  EndPoint.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

internal protocol EndPoint {
    var url: URL? { get }
}

/// Defines the API endpoints for listing movies and retrieving movie
/// metadata from the Archive.org database.
internal enum ArchiveEndPoint: EndPoint {
    /**
     Used to retrieve a list a the most recently added movies.
     - note: maximum movies in response is 50
     */
    case recentlyAdded
    /**
     Used to retrieve a list a all the movies for a given category and page.
     - Parameters:
        - category: The category to which the retrieved movies should belong
        - page: The page of results required.
     */
    case movies(category: PDCategory, page: Int)
    /**
     Used to retrieve the metadata for a given movie.
     - Parameters:
     - movie: The movie that you wish to retrive metadata for.
    */
    case metaData(movie: PDMovie)
    /// The url for the specified request.
    var url: URL? {
        switch self {
        /// A URL for a list of movies in a particular category comprises of
        /// 50 movies per response page, sorted in descending order of download number.
        /// Also specifies that all returned movies should exist within the `feature_films`
        /// collection, and have a mediatype of `movies`. Each movie object, will specify the
        /// identifier, average rating, description, and tile of the movie.
        case let .movies(category, page):
            let subjects = category.tags.joined(separator: " OR ")
            return URL(string: """
                https://archive.org/advancedsearch.php?\
                q=collection:(feature_films) AND \
                subject:(\(subjects)) \
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
        /// A URL for metadata for the metadata of a single movie.
        case let .metaData(movie):
            return URL(string: "https://archive.org/metadata/\(movie.identifier)")
        case .recentlyAdded:
            return URL(string: """
                https://archive.org/advancedsearch.php?\
                q=collection:(feature_films)\
                AND mediatype:(movies)\
                &fl[]=identifier\
                &fl[]=avg_rating\
                &fl[]=description\
                &fl[]=title\
                &sort[]=addeddate+desc&sort[]=&sort[]=\
                &rows=50\
                &output=json\
                &page=1
                """.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        }
    }
}
