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
    var currentString = ""
    
    var userToSend:PFUser?
    var wallet:Wallet?
    
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
        self.showLoading()
        let valueString:NSString = self.valueField.text!
        let value:Int = ((valueString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray).componentsJoinedByString("") as NSString).integerValue
        APIManager.sharedInstance.saveTransactionToUser(userToSend!, value: value
            , senderWallet: wallet!
            , senderDescription: self.descriptionField.text
            ) { (error) -> Void in
                if error != nil {
                    let alert = UIAlertView(title: "Error"
                        , message: error!.description
                        , delegate: nil
                        , cancelButtonTitle: "Ok")
                    alert.show()
                }

                self.hideLoading()
                if(error == nil) {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
        }
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
