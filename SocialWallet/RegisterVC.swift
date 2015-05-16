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
    
    func initTextFields() {
        self.firstnameField.delegate = self
        self.lastnameField.delegate = self
        self.emailField.delegate = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
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
        let vc:UIViewController = self.instantiateViewControlerFromStoryboard("FirstTime", sbId: "Authentication")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(sender: AnyObject) {
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
                let alert = UIAlertView(title: "Warning"
                    , message: error!.description
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
