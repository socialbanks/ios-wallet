//
//  DrawerMenuVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class DrawerMenuVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func configurationsAction(sender: AnyObject) {
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        var alert = UIAlertController(title: "Logout", message: "Do you really wish to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert :UIAlertAction!) in
            
            PFUser.logOut()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showAuhtentication(true)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
