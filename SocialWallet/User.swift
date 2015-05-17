//
//  User.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    /*
    required init?(dictionary: NSDictionary) {
        super.init()
        
        let puser:PFUser = PFUser()
        puser.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
        
        self.showLoading()
        puser.signUpInBackgroundWithBlock { (result, error) -> Void in
            if error == nil {
                println("registered and logged as ", PFUser.currentUser())
                self.registerWasSuccessful()
            } else {
                //WARNING: ver todos erros possiveis do parse!!
                println("%@", error!.description)
                let alert = UIAlertView(title: "Warning"
                    , message: error!.description
                    , delegate: nil
                    , cancelButtonTitle: "Ok")
                alert.show()
            }
            self.hideLoading()
        }
    }*/
}