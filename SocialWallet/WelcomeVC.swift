//
//  WelcomeVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/10/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class WelcomeVC: BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    func initTextFields() {
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLoad() {
        initTextFields()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func loginAction(sender: AnyObject) {
        self.showLoading()
        
        PFUser.logInWithUsernameInBackground(self.usernameField.text!, password:self.passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                //println("logged as ", user!)
                self.loginWasSuccessful()
            } else {
                //WARNING: ver todos erros possiveis do parse!!
                println("%@", error!.description)
                let alert = UIAlertView(title: "Warning"
                    , message: "Incorrect user name and password"
                    , delegate: nil
                    , cancelButtonTitle: "Ok")
                alert.show()
            }
            
            self.hideLoading()
            
        }
        
    }
    
    func loginWasSuccessful() {
        AppManager.sharedInstance.userLocalData = UserLocalData(parseId: PFUser.currentUser()!.objectId!)
        let vc:UIViewController = self.instantiateViewControlerFromStoryboard("FirstTime", sbId: "Authentication")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
