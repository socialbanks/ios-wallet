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
    /*func saveTransaction(bitcoinAddress:String, completion: (results:[Wallet]) -> Void) {
        let queryWallet:PFQuery = PFQuery(className: "Wallet")
        queryWallet.whereKey("bitcoinAddress", equalTo: bitcoinAddress)
        
        if Network.hasConnectivity() {
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    println(results)
                    completion(results: results as! [Wallet])
                }
            })
        }
    }*/
    
    //MARK: - Queries
    func getWalletsFromCurrentUser(completion: (results:[Wallet]) -> Void) {
        //let query:PFQuery = PFQuery(className: "Wallet")
        let relation = PFUser.currentUser()!.relationForKey("wallet")
        let query = relation.query()!
        query.includeKey("socialBank")
        
        if Network.hasConnectivity() {
            relation.query()?.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
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
                    println(results)
                    completion(results: results as! [SocialBank])
                }
            })
        }
    }
    
    func getWalletFromBitcoinAddres(bitcoinAddress:String, completion: (result:Wallet) -> Void) {
        let query:PFQuery = PFQuery(className: "Wallet")
        query.whereKey("bitcoinAddress", equalTo: bitcoinAddress)
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
    
    func getUsersWithEmail(email:String, completion: (results:[PFUser]) -> Void) {
        var query:PFQuery = PFUser.query()!;
        query.whereKey("email",  containsString: email)
        if Network.hasConnectivity() && !email.isEmpty {
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
                    println(results)
                    completion(results: results as! [PFUser])
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
                    println(results)
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