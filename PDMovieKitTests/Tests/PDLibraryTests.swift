//
//  PDLibraryTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDLibraryTests: XCTestCase {
    
    var session: MockDecodableSession!
    var categoryType: PDCategoryProtocol.Type!
    
    override func setUp() {
        categoryType = MockCategory.self
        MockCategory.categories = nil
        MockCategory.error = nil
        session = MockDecodableSession()
    }
    
    func test_failure_no_error_returns_fallback_error() {
        let exp = expectation(description: "fallback error")
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, PDLibrary.Errors.loading)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_category_failure_returns_category_error() {
        let exp = expectation(description: "category failure")
        MockCategory.error = NSError(domain: "FakeCategoryError", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, MockCategory.error! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_recently_added_failure_returns_error() {
        let exp = expectation(description: "recently failure")
        session.recentlyAddedError = NSError(domain: "fakerecenterror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.recentlyAddedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_most_watched_failure_returns_error() {
        let exp = expectation(description: "most watched failure")
        session.mostWatchedError = NSError(domain: "fakewatchederror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.mostWatchedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_top_rated_failure_returns_error() {
        let exp = expectation(description: "top rated failure")
        session.topRatedError = NSError(domain: "faketopratederror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.topRatedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

}
