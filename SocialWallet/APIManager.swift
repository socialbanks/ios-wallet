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
    
    
    //MARK: - Queries
    func getWalletsFromCurrentUser(completion: (results:[Wallet]) -> Void) {
        //let query:PFQuery = PFQuery(className: "Wallet")
        
        if Network.hasConnectivity() {
            let relation = PFUser.currentUser()!.relationForKey("wallet")
            relation.query()?.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if (error != nil) {
                    // There was an error
                } else {
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