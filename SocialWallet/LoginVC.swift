//
//  LoginVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

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
        let t:NSThread = NSThread(target: self, selector:"loginWasSuccessful", object: nil)
        t.start()
        
        /*
        NSThread* myThread = [[NSThread alloc] initWithTarget:self
            selector:@selector(myThreadMainMethod:)
        object:nil];
        [myThread start];
        
        
        self.showLoading()
        NSThread.sleepForTimeInterval(2)
        self.hideLoading()
        */
        //loginWasSuccessful()
    }
    
    func loginWasSuccessful() {
        NSThread.sleepForTimeInterval(3)
        self.hideLoading()
        let vc:UIViewController = self.instantiateViewControlerFromStoryboard("FirstTime", sbId: "Authentication")
        self.presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hides keyboard on return press
        textField.resignFirstResponder()
        return true
    }
    
    

}
