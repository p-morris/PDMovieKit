//
//  PDLibrary.swift
//  PDMovieKit
//
//  Created by Peter Morris on 04/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

public struct PDLibrary {
    let featured: [PDMovie]
    let topRated: [PDMovie]
    let mostWatched: [PDMovie]
    let recentlyAdded: [PDMovie]
    let categories: [PDCategory]
}
