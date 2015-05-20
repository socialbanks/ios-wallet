//
//  AppDelegate.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //private let fix = PFUser.hash() // here's the weird trick
    
    var window: UIWindow?
    var drawerController: MMDrawerController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Fabric
        Fabric.with([Crashlytics()])
        
        // Setting the settings
        AppManager.sharedInstance.debugMode = false;
        
        
        // UI settings
        // removing navigation bar separator and shadow
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
        // Initializing Parse
        Parse.enableLocalDatastore()
        Parse.setApplicationId("bCOd9IKjrpxCPGYQfyagabirn7pYFjYTvJqkq1x1", clientKey: "ug8CJXOxrkKZXlHIGKYAMaINXX9gCb1kwMgMr0ye")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        // Registering subclasses
        SocialBank.registerSubclass()
        Wallet.registerSubclass()
        Transaction.registerSubclass()
        
        
        // Checking current logged user:
        if( PFUser.currentUser() != nil ) {
            AppManager.sharedInstance.userLocalData = UserLocalData(parseId: PFUser.currentUser()!.objectId!)
            if AppManager.sharedInstance.userLocalData!.secret != nil {
                AppManager.sharedInstance.userLocalData!.generatePrivateAddressWithSecret()
                self.showMenu(false)
            } else {
                let alert = UIAlertView(title: "Error"
                    , message: "Your private key was not found in this device. You have been logged out. Log in again and redeem your wallet with your 24 words."
                    , delegate: nil
                    , cancelButtonTitle: "Ok")
                alert.show()
                PFUser.logOut() // Force user to log in again - error with his address
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showAuhtentication(animated: Bool) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil);
        let navVC = storyboard.instantiateInitialViewController() as! UINavigationController
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if (animated) {
            UIView.transitionFromView(self.window!.rootViewController!.view, toView: navVC.view, duration: 0.65, options:UIViewAnimationOptions.TransitionCrossDissolve , completion: {(fininshed: Bool) -> ()  in
                self.window!.rootViewController = navVC
                self.window?.makeKeyAndVisible()
            })
        } else {
            self.window!.rootViewController = navVC
            self.window?.makeKeyAndVisible()
        }
    }
    
    func showMenu(animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let leftDrawer = storyboard.instantiateViewControllerWithIdentifier("DrawerMenu") as! UITableViewController;
        
        let center = storyboard.instantiateViewControllerWithIdentifier("SocialBankPickerNavigationController") as! UINavigationController;
        
        self.drawerController = MMDrawerController(centerViewController: center, leftDrawerViewController: leftDrawer)
        
        drawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.All
        drawerController?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        drawerController?.maximumLeftDrawerWidth = 210
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if (animated) {
            UIView.transitionFromView(self.window!.rootViewController!.view, toView: drawerController!.view, duration: 0.65, options:UIViewAnimationOptions.TransitionCrossDissolve , completion: {(fininshed: Bool) -> ()  in
                self.window!.rootViewController = self.drawerController!
                self.window?.makeKeyAndVisible()
            })
            
        } else {
            self.window!.rootViewController = self.drawerController!
            self.window?.makeKeyAndVisible()
        }
    }

}

