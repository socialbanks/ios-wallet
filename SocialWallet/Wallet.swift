//
//  Wallet.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Parse

class Wallet: PFObject, PFSubclassing {
    
    class func parseClassName() -> String {
        return "Wallet"
    }
    
    func getBitcoinAddress() -> String {
        return self.objectForKey("bitcoinAddress")! as! String
    }
    
    func getBalance() -> Int {
        return self.objectForKey("balance")! as! Int
    }
    
    func getSocialBank() -> SocialBank {
        let object = self.objectForKey("socialBank") as! SocialBank
        object.fetchIfNeeded()
        return object
    }
    
}