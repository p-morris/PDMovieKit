//
//  PDLibrary.swift
//  PDMovieKit
//
//  Created by Peter Morris on 04/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

protocol PDCategoryProtocol {
    static func allCategories(completion: ([PDCategory]?, Error?) -> Void)
}
extension PDCategory: PDCategoryProtocol { }

protocol DecodableSession {
    func decodableRequest<T>(with endPoint: EndPoint, decoder: JSONDecoder, completion: @escaping (T?, Error?) -> Void) where T: Decodable
}
extension URLSession: DecodableSession { }

/// Used to represent featured PDMovie content, and categories.
public struct PDLibrary {
    /// The latest 5 PDMovies
    public let featured: [PDMovie]
    /// The top rated 50 movies
    public let topRated: [PDMovie]
    /// The 50 most downloaded movies
    public let mostWatched: [PDMovie]
    /// The 50 most recently added movies
    public let recentlyAdded: [PDMovie]
    /// All movie categories
    public let categories: [PDCategory]
    /// Represents errors related to loading the PDLibrary data
    internal enum Errors {
        static let loading = NSError(
            domain: "PDLibraryErrorDomain",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Failed to load library."]
        )
    }
    public static func library(session: URLSession, completionQueue: OperationQueue, completion: @escaping (PDLibrary?, Error?) -> Void) {
        self.library(categoryType: PDCategory.self, session: session, completionQueue: completionQueue, completion: completion)
    }
    internal static func library(categoryType: PDCategoryProtocol.Type,
                                 session: DecodableSession = URLSession.shared,
                                 completionQueue: OperationQueue = OperationQueue.main,
                                 completion: @escaping (PDLibrary?, Error?) -> Void) {
        // Categories request
        categoryType.allCategories { (categories, categoriesError) in
            // Recently added request
            session.decodableRequest(with: ArchiveEndPoint.recentlyAdded, decoder: JSONDecoder()) { (recent: PDMovieResponse?, addedError) in
                // Most watched request
                session.decodableRequest(with: ArchiveEndPoint.mostWatched, decoder: JSONDecoder()) { (popular: PDMovieResponse?, popularError) in
                    // Top rated request
                    session.decodableRequest(with: ArchiveEndPoint.topRated, decoder: JSONDecoder()) { (topRated: PDMovieResponse?, topError) in
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
