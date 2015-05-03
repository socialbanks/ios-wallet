//
//  PayVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "qrCodeScanned:",
            name: "QR-Code Scanned",
            object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func qrCodeScanned(notification: NSNotification) {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        self.addressTextField.text = userInfo["address"]!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
