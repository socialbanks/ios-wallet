//
//  User.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation

class User: NSObject {
    var id:Int!
    var firstname: String!
    var lastname: String!
    var email: String!
    var username: String!
    var password: String!   // THIS CANNOT GO TO PRODUCTION!!
    
    required init?(dictionary: NSDictionary) {
        super.init()
        
        if let value = dictionary["firstname"] as? String {
            self.firstname = value
        } else {
            return nil
        }
        
        if let value = dictionary["lastname"] as? String {
            self.lastname = value
        } else {
            return nil
        }
        
        if let value = dictionary["email"] as? String {
            self.email = value
        } else {
            return nil
        }
            
        if let value = dictionary["username"] as? String {
            self.username = value
        } else {
            return nil
        }
            
        if let value = dictionary["password"] as? String {
            self.password = value
        } else {
            return nil
        }
        
    }
}