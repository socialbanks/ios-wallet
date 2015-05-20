//
//  PayTabVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class PayTabVC: BaseTableVC, UITextFieldDelegate {
    
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
    var currentString = ""
    
    var wallet:Wallet?
    var transaction:Transaction = Transaction(className:"Transaction")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionField.delegate = self
        self.valueField.delegate = self
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
        self.showLoading()
        if receiverDescription!.isEmpty {
            receiverDescription = "Received from " + (PFUser.currentUser()!.objectForKey("email")! as! String)
        }
        let valueString:NSString = self.valueField.text!
        let value:Int = ((valueString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray).componentsJoinedByString("") as NSString).integerValue
        APIManager.sharedInstance.saveTransaction(bitcoinAddress!, value: value
            , receiverDescription: receiverDescription!
            , senderWallet: wallet!
            , senderDescription: descriptionField.text,
            completion: { (error) -> Void in
                if error != nil {
                    
                }
                self.hideLoading()
                self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        if(textField.isEqual(self.descriptionField)) {
            return true
        }
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(string: currentString)
        default:
            var array = Array(string)
            var currentStringArray = Array(currentString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(string: currentString)
            }
        }
        return false
    }
    
    func formatCurrency(#string: String) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        var numberFromField = (NSString(string: currentString).doubleValue)/100
        valueField.text = formatter.stringFromNumber(numberFromField)
    }

}
