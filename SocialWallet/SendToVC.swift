//
//  SendToVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/17/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class SendToVC: BaseTableVC, UITextFieldDelegate {
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var userToSend:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueField.delegate = self
        descriptionField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        fullnameLabel.text = (userToSend!["firstName"] as! String) + " " + (userToSend!["lastName"] as! String)
        emailLabel.text = userToSend!.email!
        if let photo = userToSend!["image"] as? PFFile {
            let imageData:NSData = photo.getData()!
            photoImageView.image = UIImage(data: imageData)
        }
        
    }
    
    
    @IBAction func sendAction(sender: AnyObject) {
        
    }
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
