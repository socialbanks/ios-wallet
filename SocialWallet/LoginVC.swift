//
//  LoginVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginVC: BaseTableVC, UITextFieldDelegate {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func initTextFields() {
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        self.showLoading()
        
        PFUser.logInWithUsernameInBackground(self.userTextField.text!, password:self.passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                println("registered and logged as ", user!)
                self.loginWasSuccessful()
            } else {
                //WARNING: ver todos erros possiveis do parse!!
                println("%@", error!.description)
                let alert = UIAlertView(title: "Warning"
                    , message: error!.description
                    , delegate: nil
                    , cancelButtonTitle: "Ok")
                alert.show()
            }
            
            self.hideLoading()
            
        }

    }
    
    func loginWasSuccessful() {
        self.hideLoading()
        let vc:UIViewController = self.instantiateViewControlerFromStoryboard("FirstTime", sbId: "Authentication")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hides keyboard on return press
        textField.resignFirstResponder()
        return true
    }

}
