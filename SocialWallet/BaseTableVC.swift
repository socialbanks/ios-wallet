//
//  BaseTableVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class BaseTableVC: UITableViewController {
    
    lazy var HUD:MBProgressHUD = {
        let tmpHUD:MBProgressHUD = MBProgressHUD(view: self.view)
        self.view.addSubview(tmpHUD)
        //tmpHUD.delegate = self
        tmpHUD.labelText = "Aguarde"
        tmpHUD.detailsLabelText = "Carregando dados..."
        //tmpHUD.square = true
        return tmpHUD
        }()
    
    func showLoading() {
        self.showNetWorkActivity()
        self.HUD.show(true)
    }
    
    func hideLoading() {
        self.showNetWorkActivity()
        self.HUD.hide(true)
    }
    
    func showNetWorkActivity() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hideNetWorkActivity() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupLeftMenuButton() {
        let leftDrawerButton:MMDrawerBarButtonItem = MMDrawerBarButtonItem(target:self, action:"leftDrawerButtonPress")
        leftDrawerButton.tintColor = UIColor.blueColor()
        self.navigationItem.leftBarButtonItem = leftDrawerButton
    }
    
    func leftDrawerButtonPress() {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func removeLeftBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    }
    
    func instantiateViewControlerFromStoryboard(vcId: String, sbId: String) -> UIViewController {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: sbId, bundle: nil)
        let vc:UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(vcId) as! UIViewController
        return vc
    }

}
