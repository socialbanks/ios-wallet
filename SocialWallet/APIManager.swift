//
//  APIManager.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/9/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Parse

//get_balances("1Ko36AjTKYh6EzToLU737Bs2pxCsGReApK")

class APIManager {
    
    //MARK: - Singleton
    class var sharedInstance : APIManager {
        struct Static {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }

    //MARK: - Saves
    func saveWallet(bitcoinAddress:String, socialBank:SocialBank, completion:() -> Void) {
        let relation:PFRelation = PFUser.currentUser()!.relationForKey("wallet");
        let newWallet:Wallet = Wallet(className: "Wallet")
        newWallet.setObject(0, forKey: "balance")
        newWallet.setObject(AppManager.sharedInstance.userLocalData!.getPublicKey(), forKey: "bitcoinAddress")
        newWallet.setObject(AppManager.sharedInstance.userLocalData!.bt!.key.privateKey, forKey: "wif_remove")
        newWallet.setObject(PFUser.currentUser()!, forKey: "user")
        socialBank.fetchIfNeeded()
        newWallet.setObject(socialBank, forKey: "socialBank")
        newWallet.save()
        
        relation.addObject(newWallet);
        PFUser.currentUser()!.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if(error != nil || !success) {
                // an error has occured
            }else{
                completion()
            }
        }
    }
    
    func saveTransaction(receiverAddress:String, value:Int, receiverDescription:String, senderWallet:Wallet, senderDescription:String, completion: (error:NSError?) -> Void) {
        let recQuery:PFQuery = PFQuery(className: "Wallet")
        recQuery.whereKey("bitcoinAddress", equalTo: receiverAddress)
        recQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error: NSError?) -> Void in
            if(error != nil) {
                // There was an error
                completion(error: error!)
                return
            }
            
            if let recWallet:Wallet? = results?[0] as? Wallet {
                let trans:Transaction = Transaction(className: "Transaction")
                // TODO: A virgula maldita!
                trans.setObject(value, forKey: "value")
                trans.setObject(senderWallet, forKey: "senderWallet")
                //trans.setObject(senderWallet.getBitcoinAddress(), forKey: "senderAddress")
                trans.setObject(senderDescription, forKey: "senderDescription")
                trans.setObject(recWallet!, forKey: "receiverWallet")
                //trans.setObject(recWallet!.getBitcoinAddress(), forKey: "receiverAddress")
                trans.setObject(receiverDescription, forKey: "receiverDescription")
                var error:NSError?
                trans.save(&error)
                
                completion(error: error)
                
            }else{
                println("error - wallet not found...")
                completion(error: nil)
            }
            
        }
    }
    
    func saveTransactionToUser(toUser:PFUser, value:Int, senderWallet:Wallet, senderDescription:String, completion: (error:NSError?) -> Void) {
        let recQuery:PFQuery = PFQuery(className: "Wallet")
        recQuery.whereKey("user", equalTo: toUser)
        recQuery.whereKey("socialBank", equalTo: senderWallet.getSocialBank())
        
        recQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error: NSError?) -> Void in
            if(error != nil) {
                // There was an error
                completion(error: error!)
                return
            }
            
            if let recWallet:Wallet? = results?[0] as? Wallet {
                let trans:Transaction = Transaction(className: "Transaction")
                // TODO: A virgula maldita!
                trans.setObject(value, forKey: "value")
                trans.setObject(senderWallet, forKey: "senderWallet")
                //trans.setObject(senderWallet.getBitcoinAddress(), forKey: "senderAddress")
                trans.setObject(senderDescription, forKey: "senderDescription")
                //trans.setObject(recWallet!, forKey: "receiverWallet")
                trans.setObject(recWallet!.getBitcoinAddress(), forKey: "receiverAddress")
                trans.setObject("Received from " + (PFUser.currentUser()!.objectForKey("email") as! String), forKey: "receiverDescription")
                var error:NSError?
                trans.save(&error)
                
                completion(error: error)
                
            }else{
                println("error - wallet not found...")
                let error:NSError = NSError(domain: "user doesn`t have a wallet with yours` socialbank", code: 404, userInfo: nil)
                completion(error: error)
            }
            
        }
    }
    
    
    //MARK: - Queries
    func getWalletsFromCurrentUser(completion: (results:[Wallet]) -> Void) {
        //let query:PFQuery = PFQuery(className: "Wallet")
        //let relation = PFUser.currentUser()!.relationForKey("wallet")
        let query = PFQuery(className: "Wallet")
        query.whereKey("bitcoinAddress", equalTo: AppManager.sharedInstance.userLocalData!.bt!.address)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.includeKey("socialBank")
        
        if Network.hasConnectivity() {
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    completion(results: results as! [Wallet])
                }
            })
        }
    }
    
    func getSocialBanksWithName(name:String, completion: (results:[SocialBank]) -> Void) {
        let query:PFQuery = PFQuery(className: "SocialBank")
        query.whereKey("name", containsString: name)
        if Network.hasConnectivity() && !name.isEmpty {
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    //println(results)
                    completion(results: results as! [SocialBank])
                }
            })
        }
    }
    
    func getWalletFromBitcoinAddres(bitcoinAddress:String, completion: (result:Wallet) -> Void) {
        let query:PFQuery = PFQuery(className: "Wallet")
        query.whereKey("bitcoinAddress", equalTo: bitcoinAddress)
        query.whereKey("user", notEqualTo: PFUser.currentUser()!)
        query.includeKey("user")
        query.includeKey("socialBank")
        if Network.hasConnectivity() {
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    if(results!.count > 0) {
                        completion(result: results![0] as! Wallet)
                    }
                }
            })
        }
    }
    
    func getWalletsWithUserEmailAndSocialBank(email:String, socialBank:SocialBank, completion: (results:[Wallet]) -> Void) {
        let userQuery = PFUser.query()!
        userQuery.whereKey("email", containsString: email)
        let walletQuery = PFQuery(className: "Wallet")
        walletQuery.whereKey("user", notEqualTo: PFUser.currentUser()!)
        walletQuery.whereKey("user", matchesQuery: userQuery)
        walletQuery.whereKey("socialBank", equalTo: socialBank)
        walletQuery.includeKey("user")
        if Network.hasConnectivity() && !email.isEmpty {
            walletQuery.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    //println(results)
                    completion(results: results as! [Wallet])
                }
            })
        }
    }
    
    func getTransactionsFromWallet(wallet:Wallet, completion: (results:[Transaction]) -> Void) {
        //let query:PFQuery = PFQuery(className: "Wallet")
        
        let querySender:PFQuery = PFQuery(className: "Transaction")
        querySender.whereKey("senderWallet", equalTo: wallet)
        let queryReceiver:PFQuery = PFQuery(className: "Transaction")
        queryReceiver.whereKey("receiverWallet", equalTo: wallet)
        
        let superQuery = PFQuery.orQueryWithSubqueries(NSArray(objects: queryReceiver, querySender) as [AnyObject])
        superQuery.includeKey("senderWallet")
        superQuery.includeKey("receiverWallet")
        superQuery.orderByDescending("createdAt")
        
        if Network.hasConnectivity() {
            superQuery.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    //println(results)
                    completion(results: results as! [Transaction])
                }
            })
        }
        
    }
    
    
    // MARK: - Cloud functions
    func getBalances(completion: (results:AnyObject?, error:NSError?) -> Void) {
        
        PFCloud.callFunctionInBackground("get_balances", withParameters: ["address":["1Ko36AjTKYh6EzToLU737Bs2pxCsGReApK"]]) { (results, error) -> Void in
            if((error) != nil) {
                println("error on getBalances - ", error!.description)
            }else{
                completion(results: results, error: error)
            }
        }
    
    }
    
}