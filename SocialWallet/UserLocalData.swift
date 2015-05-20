//
//  UserData.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/9/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Security

class UserLocalData: NSObject {
    
    var id:String
    var secret:String?
    var bt:BTBIP32Key?
    
    required init?(parseId: String) {
        self.id = parseId
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.secret = defaults.objectForKey("secret") as? String
        if self.secret != nil {
            var secretString:NSString = self.secret! as NSString
            self.bt = BTBIP32Key(secret: secretString.hexToData(), andPubKey: nil, andChain: nil, andPath: nil)
        }
    }
    
    required init?(parseId: String, words:String) {
        self.id = parseId
        let secret:NSData? = BTBIP39.sharedInstance().toEntropy(words)
        
        if(secret == nil) {
            self.bt = nil
            return
        }
        
        var secretString:NSString = secret!.description as NSString
        secretString = secretString.stringByReplacingOccurrencesOfString(" ", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString("<", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString(">", withString: "")
        self.secret = secretString as String
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(secretString, forKey: "secret")
        defaults.synchronize()
        
        self.bt = BTBIP32Key(secret: secret, andPubKey: nil, andChain: nil, andPath: nil)

    }
    
    func generatePrivateAddress() {
        // Random NSDATA
        let seed:NSMutableData = NSMutableData(length: 256)!
        SecRandomCopyBytes(kSecRandomDefault, 256, UnsafeMutablePointer<UInt8>(seed.mutableBytes))
        self.bt = BTBIP32Key(seed: NSData(data:seed))
        
        let secretData:NSData = self.bt!.secret
        var secretString:NSString = secretData.description as NSString
        secretString = secretString.stringByReplacingOccurrencesOfString(" ", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString("<", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString(">", withString: "")
        self.secret = secretString as String
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(secretString, forKey: "secret")
        defaults.synchronize()
    }
    
    func generatePrivateAddressWithSecret() {
        var secretString:NSString = self.secret! as NSString
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(secretString, forKey: "secret")
        defaults.synchronize()
        
        self.bt = BTBIP32Key(secret: secretString.hexToData(), andPubKey: nil, andChain: nil, andPath: nil)
    }
    
    func redeemPrivateAddress(words:String) {
        let secret:NSData? = BTBIP39.sharedInstance().toEntropy(words)
        
        if(secret == nil) {
            self.bt = nil
            return
        }
        
        var secretString:NSString = secret!.description as NSString
        secretString = secretString.stringByReplacingOccurrencesOfString(" ", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString("<", withString: "")
        secretString = secretString.stringByReplacingOccurrencesOfString(">", withString: "")
        self.secret = secretString as String
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(secretString, forKey: "secret")
        defaults.synchronize()
        
        self.bt = BTBIP32Key(secret: secret, andPubKey: nil, andChain: nil, andPath: nil)
    }
    
    func getWords() -> String? {
        return BTBIP39.sharedInstance().toMnemonic(self.bt?.secret)
    }
    
    func getPublicKey() -> String {
        return bt!.address
    }
    
    func verify() -> Bool {
        return self.bt != nil
    }
    
}