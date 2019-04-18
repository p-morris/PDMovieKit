//
//  PDPosterTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 18/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDPosterTests: XCTestCase {

    func test_pdposter_init() {
        let json = """
        {
            "Year": "1981",
            "Title": "A Movie",
            "Poster": "https://google.com/poster.png"
        }
        """.data(using: .utf8)
        let poster = try? JSONDecoder().decode(PDPoster.self, from: json!)
        XCTAssertNotNil(poster)
    }
    
    func test_pdposterresponse_init() {
        let json = """
        {
            "Search": [{
            "Year": "1981",
            "Title": "A Movie",
            "Poster": "https://google.com/poster.png"
        }, {
            "Year": "1981",
            "Title": "A Movie",
            "Poster": "https://google.com/poster.png"
        }, {
            "Year": "1981",
            "Title": "A Movie",
            "Poster": "https://google.com/poster.png"
        }]
        }
        """.data(using: .utf8)!
        let response = try? JSONDecoder().decode(PDPosterResponse.self, from: json)
        XCTAssertNotNil(response)
        XCTAssertEqual(response!.searchResults.count, 3)
    }
    
    

}
