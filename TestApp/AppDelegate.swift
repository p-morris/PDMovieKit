//
//  AppDelegate.swift
//  TestApp
//
//  Created by Peter Morris on 18/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit
import PDMovieKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PDLibrary.library(session: URLSession.shared, completionQueue: OperationQueue.main) { (library, error) in
            if let library = library {
                library.mostWatched.forEach {
                    $0.poster(omdbAPIKey: "b8b62708", completion: { (url) in
                        print(url?.description)
                    })
                }
            }
        }
        return true
    }


}

