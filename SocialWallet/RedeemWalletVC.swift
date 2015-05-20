//
//  RedeemWalletVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/5/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class RedeemWalletVC: BaseTableVC, UITextViewDelegate {

    @IBOutlet weak var wordsField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeLeftBarButton()
        wordsField.delegate = self
    }

    @IBAction func redeemAction(sender: AnyObject) {
        AppManager.sharedInstance.userLocalData = UserLocalData(parseId: PFUser.currentUser()!.objectId!, words: wordsField.text.lowercaseString)
        if(AppManager.sharedInstance.userLocalData!.verify()) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showMenu(true)
        }else{
            let alert = UIAlertView(title: "Error"
                , message: "Invalid words."
                , delegate: self
                , cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    // MARK: UITextField delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    

}
