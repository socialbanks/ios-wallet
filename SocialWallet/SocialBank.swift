//
//  SocialBank.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class SocialBank: PFObject, PFSubclassing {
    
    class func parseClassName() -> String {
        return "SocialBank"
    }

    
    func getName() -> String {
        return self.objectForKey("name")! as! String
    }
    
    func getImage() -> UIImage {
        let image:PFFile = self.objectForKey("image")! as! PFFile
        return UIImage(data: image.getData()!)!
    }
    
    func getSocialMoneyName() -> String {
        return self.objectForKey("socialMoneyName")! as! String
    }
    
}
