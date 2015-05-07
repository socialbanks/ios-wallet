//
//  RedeemWalletVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/5/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class RedeemWalletVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func redeemAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showMenu(true)
    }
    

}
