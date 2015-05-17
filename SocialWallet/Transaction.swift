//
//  Transaction.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Parse

class Transaction: PFObject, PFSubclassing {
    
    var isSender:Bool = false;
    
    class func parseClassName() -> String {
        return "Transaction"
    }
    
    func getReceiverAddress() -> String {
        return self.objectForKey("receiverAddress")! as! String
    }
    
    func getReceiverWallet() -> Wallet? {
        let object = self.objectForKey("receiverWallet") as? Wallet
        object?.fetchIfNeeded()
        return object
    }
    
    func getReceiverDescription() -> String? {
        return self.objectForKey("receiverDescription") as? String
    }
    
    func getSenderAddress() -> String {
        return self.objectForKey("senderAddress")! as! String
    }
    
    func getSenderWallet() -> Wallet? {
        let object = self.objectForKey("senderWallet") as? Wallet
        object?.fetchIfNeeded()
        return object
    }
    
    func getSenderDescription() -> String? {
        return self.objectForKey("senderDescription") as? String
    }
    
    func getSocialBank() -> SocialBank {
        let object = self.objectForKey("socialBank") as! SocialBank
        object.fetchIfNeeded()
        return object
    }
    
    func getUser() -> PFUser {
        let object = self.objectForKey("user") as! PFUser
        object.fetchIfNeeded()
        return object
    }
    
    func getCreatedAt() -> NSDate {
        let object = self.objectForKey("createdAt") as! NSDate
        return object
    }
    
    func getValue() -> Int {
        let object = self.objectForKey("value") as! Int
        return object
    }
    
}