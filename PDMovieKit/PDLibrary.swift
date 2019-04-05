//
//  PDLibrary.swift
//  PDMovieKit
//
//  Created by Peter Morris on 04/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

public struct PDLibrary {
    public let featured: [PDMovie]
    public let topRated: [PDMovie]
    public let mostWatched: [PDMovie]
    public let recentlyAdded: [PDMovie]
    public let categories: [PDCategory]
    internal enum Errors {
        static let loading = NSError(
            domain: "PDLibraryErrorDomain",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Failed to load library."]
        )
    }
    public static func library(session: URLSession = URLSession.shared,
                               completionQueue: OperationQueue = OperationQueue.main,
                               completion: @escaping (PDLibrary?, Error?) -> Void) {
        // Categories request
        PDCategory.allCategories { (categories, categoriesError) in
            // Recently added request
            session.decodableRequest(with: ArchiveEndPoint.recentlyAdded) { (recent: PDMovieResponse?, addedError) in
                // Most watched request
                session.decodableRequest(with: ArchiveEndPoint.mostWatched) { (popular: PDMovieResponse?, popularError) in
                    // Top rated request
                    session.decodableRequest(with: ArchiveEndPoint.topRated) { (topRated: PDMovieResponse?, topError) in
                        completionQueue.addOperation {
                            // If we have all data, initialize library object
                            if let categories = categories, let recent = recent, let popular = popular, let topRated = topRated {
                                // Featured movies are always the 5 most recently added movies
                                let featured = recent.docs[0...4]
                                // Remove the featured movies from the recent array
                                let recent = recent.docs[5..<recent.docs.count]
                                completion(PDLibrary(
                                    featured: Array(featured),
                                    topRated: topRated.docs,
                                    mostWatched: popular.docs,
                                    recentlyAdded: Array(recent),
                                    categories: categories
                                ), nil)
                            } else {
                                completion(nil, categoriesError ?? addedError ?? popularError ?? topError ?? Errors.loading)
                            }
                        }
                    }
                }
            }
        }
    }
}
