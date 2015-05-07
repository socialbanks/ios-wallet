//
//  GenerateTwelveWordsVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/5/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import UIKit

class GenerateTwelveWordsVC: BaseVC {
    
    @IBAction func understoodAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showMenu(true)
    }
    
}