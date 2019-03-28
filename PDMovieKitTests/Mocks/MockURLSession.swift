//
//  MockURLSession.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
    var returnData: Data?
    var returnError: Error?
    var returnedTask: MockURLSessionDataTask?
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(returnData, nil, returnError)
        returnedTask = MockURLSessionDataTask()
        return returnedTask!
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var didResume = false
    override func resume() {
        didResume = true
    }
}
