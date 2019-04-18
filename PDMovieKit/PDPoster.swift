//
//  PDPoster.swift
//  PDMovieKit
//
//  Created by Peter Morris on 18/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Represents a movie poster found via the OMDB API.
struct PDPoster: Decodable {
    /// The year of the movie's release
    let year: Int
    /// The title of the moview
    let title: String
    /// A URL at which the image for the poster can be found
    let posterURL: URL
    internal enum CodingKeys: String, CodingKey {
        case year = "Year", title = "Title", posterURL = "Poster"
    }
    /**
     Initializes a `PDPoster` object using a given `Decoder`.
     
     The decoder must be able to decode "Year", "Title" and "Poster" properties.
     
     - Parameter decoder: The decoder to use for retrieving property values.
     */
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try Int(container.decode(String.self, forKey: .year)) ?? 0
        self.title = try container.decode(String.self, forKey: .title)
        self.posterURL = try container.decode(URL.self, forKey: .posterURL)
    }
}

/// Represents a movie poster search response from the OMDB API.
struct PDPosterResponse: Decodable {
    /// The array of `PDPoster` objects found for this particular serach.
    let searchResults: [PDPoster]
    internal enum CodingKeys: String, CodingKey {
        case searchResults = "Search"
    }
    /**
     Initializes a `PDPoster` object using a given `Decoder`.
     
     The decoder must be able to decode "Search" array which contains JSON objects which may be parsed to `PDPoster` objects.
     
     - Parameter decoder: The decoder to use for retrieving property values.
     */
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        searchResults = try container.decode([PDPoster].self, forKey: .searchResults)
    }
}
