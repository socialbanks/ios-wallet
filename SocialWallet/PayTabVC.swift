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
    
    var bitcoinAddress:String?
    var receiverDescription:String?
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userphotoImageView: UIImageView!
    
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var wallet:Wallet?
    var transaction:Transaction = Transaction(className:"Transaction")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.sharedInstance.getWalletFromBitcoinAddres(bitcoinAddress!, completion: { (result) -> Void in
            
            let user:PFUser = result.getUser()
            self.fullnameLabel.text = user.objectForKey("firstName") as? String
            self.emailLabel.text = user.email
            if let photo = user["image"] as? PFFile {
                let imageData:NSData = photo.getData()!
                self.userphotoImageView.image = UIImage(data: imageData)
            }
            
        })
        
    }
    
    func loadFromUser(user:PFUser) {
        fullnameLabel.text = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
        emailLabel.text = user.email!
        if let photo = user["image"] as? PFFile {
            let imageData:NSData = photo.getData()!
            userphotoImageView.image = UIImage(data: imageData)
        }
    }
    
    @IBAction func payAction(sender: AnyObject) {
        
    }

}
