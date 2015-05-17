//
//  NetworkManager.swift
//  SGPmobile
//
//  Created by Felipe Oliveira on 1/12/15.
//  Copyright (c) 2015 Felipe Oliveira. All rights reserved.
//

import Foundation

class NetworkManager {
    
    //MARK: - Singleton
    class var sharedInstance : NetworkManager {
        struct Static {
            static let instance : NetworkManager = NetworkManager()
        }
        return Static.instance
    }
    
    class func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
}

typealias Network = NetworkManager