//
//  Transaction.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation

class Transaction: NSObject {
    
    var date:String!
    var descriptionText: String!
    var amount: Float!
    
    required init?(dictionary: NSDictionary) {
        super.init()
        
        if let value = dictionary["date"] as? String {
            self.date = value
        } else {
            return nil
        }
        
        if let value = dictionary["description"] as? String {
            self.descriptionText = value
        } else {
            return nil
        }
        
        if let value = dictionary["amount"] as? Float {
            self.amount = value
        } else {
            return nil
        }
        
    }

}