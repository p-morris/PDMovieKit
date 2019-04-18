//
//  String+PercentEncoding.swift
//  PDMovieKit
//
//  Created by Peter Morris on 18/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

extension String {
    func addingPercentEncoding() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
