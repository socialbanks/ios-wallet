//
//  PayTabVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class PayTabVC: BaseTableVC {
    
    /* transaction
    "createdAt": "2015-05-13T00:46:52.712Z",
    "objectId": "TK8UpMNcBC",
    "receiverDescription": "",
    "receiverWallet": {
        "__type": "Pointer",
        "className": "Wallet",
        "objectId": "zBWr4SjRLl"
    },
    "senderDescription": "xffgg",
    "senderWallet": {
        "__type": "Pointer",
        "className": "Wallet",
        "objectId": "DwkVDVRWeW"
    },
    "updatedAt": "2015-05-13T00:46:52.712Z",
    "value": 508
    */
    
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userphotoImageView: UIImageView!
    
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var transaction:PFObject = PFObject(className: "Transaction")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadFromUser(user:PFUser) {
        
    }
    
    @IBAction func payAction(sender: AnyObject) {
        
    }

}
