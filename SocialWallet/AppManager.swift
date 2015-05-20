//
//  AppManager.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/9/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation

class AppManager {
    
    var userLocalData:UserLocalData?
    var debugMode:Bool!
    
    //MARK: - Singleton
    class var sharedInstance : AppManager {
        struct Static {
            static let instance : AppManager = AppManager()
        }
        return Static.instance
    }
    
}