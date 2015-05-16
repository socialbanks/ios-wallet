//
//  UserData.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/9/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation


class UserData: NSObject {
    var id:Int!
    
    required init?(parseId: Int) {
        self.id = parseId
    }
    
}