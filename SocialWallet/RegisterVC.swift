//
//  RegisterVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class RegisterVC: BaseTableVC, UITextFieldDelegate {

    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    func initTextFields() {
        self.firstnameField.delegate = self
        self.lastnameField.delegate = self
        self.emailField.delegate = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Cadastro"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerWasSuccessful() {
        AppManager.sharedInstance.userLocalData = UserLocalData(parseId: PFUser.currentUser()!.objectId!)
        let vc:UIViewController = self.instantiateViewControlerFromStoryboard("FirstTime", sbId: "Authentication")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        
        if firstnameField.text.isEmpty {
            let alert = UIAlertView(title: "Warning"
                , message: "Type in your first name"
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        if lastnameField.text.isEmpty {
            let alert = UIAlertView(title: "Warning"
                , message: "Type in your last name"
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        if emailField.text.isEmpty {
            let alert = UIAlertView(title: "Warning"
                , message: "Type in your email"
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        if usernameField.text.isEmpty {
            let alert = UIAlertView(title: "Warning"
                , message: "Type in your user name"
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        if passwordField.text.isEmpty {
            let alert = UIAlertView(title: "Warning"
                , message: "Type in your password"
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        if confirmPasswordField.text != passwordField.text {
            let alert = UIAlertView(title: "Error"
                , message: "Password confirmation does not match."
                , delegate: nil
                , cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        let dict:NSDictionary = ["firstName":firstnameField.text
            ,"lastName": lastnameField.text
            ,"email": emailField.text
            ,"username": usernameField.text
            ,"password": passwordField.text
        ]
        let puser:PFUser = PFUser()
        puser.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
        
        self.showLoading()
        puser.signUpInBackgroundWithBlock { (result, error) -> Void in
            if error == nil {
                println("registered and logged as ", PFUser.currentUser())
                self.registerWasSuccessful()
            } else {
                //WARNING: ver todos erros possiveis do parse!!
                println("%@", error!.description)
                let alert = UIAlertView(title: "Error"
                    , message: "Registering failed. Please, try again later."
                    , delegate: nil
                    , cancelButtonTitle: "Ok")
                alert.show()
            }
            self.hideLoading()
        }

    }
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hides keyboard on return press
        textField.resignFirstResponder()
        return true
    }

}
