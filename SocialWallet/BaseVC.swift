//
//  BaseVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/4/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    lazy var HUD:MBProgressHUD = {
        let tmpHUD:MBProgressHUD = MBProgressHUD(view: self.view)
        self.view.addSubview(tmpHUD)
        //tmpHUD.delegate = self
        tmpHUD.labelText = "Aguarde"
        tmpHUD.detailsLabelText = "Carregando dados..."
        //tmpHUD.square = true
        return tmpHUD
        }()
    
    //MARK: UI Functions
    
    func showLoading() {
        self.showNetWorkActivity()
        self.HUD.show(true)
    }
    
    func hideLoading() {
        self.hideNetWorkActivity()
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Navigation bar functions
    func setDefaultTitleLogo() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        logo.contentMode = .ScaleAspectFit
        logo.image = UIImage(named: "logo_socialbanks")
        self.navigationItem.titleView = logo
    }
    
    func setupLeftMenuButton() {
        let leftDrawerButton:MMDrawerBarButtonItem = MMDrawerBarButtonItem(target:self, action:"leftDrawerButtonPress")
        leftDrawerButton.tintColor = UIColor.whiteColor()
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
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
