//
//  ToMainVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class ToMainVC: UIViewController {
    override func viewDidLoad() {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:UIViewController = mainStoryboard.instantiateInitialViewController() as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        /*self.transitionFromViewController(self, toViewController: vc, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil) { (Bool) -> Void in
            
        }*/
    }

}
