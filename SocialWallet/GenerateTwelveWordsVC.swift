//
//  GenerateTwelveWordsVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/5/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import UIKit
import Parse

class GenerateTwelveWordsVC: BaseTableVC {
    
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var understoodButton: UIButton!
    @IBOutlet weak var wordsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppManager.sharedInstance.userLocalData = UserLocalData(parseId: PFUser.currentUser()!.objectId!)
        AppManager.sharedInstance.userLocalData!.generatePrivateAddress()
        wordsLabel.text =  AppManager.sharedInstance.userLocalData!.getWords()
        self.removeLeftBarButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func understoodAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showMenu(true)
    }
    
}