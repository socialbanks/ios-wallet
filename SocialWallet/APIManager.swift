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