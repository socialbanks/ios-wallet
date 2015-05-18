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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //private let fix = PFUser.hash() // here's the weird trick
    
    var window: UIWindow?
    var drawerController: MMDrawerController?
    
    func getPrivKey(index:uint, master:BTBIP32Key) -> BTBIP32Key {
        let purpose = master.deriveHardened(44)
        let coinType = purpose.deriveHardened(0)
        let account = coinType.deriveHardened(0)
        let externalPriv = account.deriveSoftened(0)
        return externalPriv.deriveSoftened(index)
    }
    
    /// Return hexadecimal string representation of NSData bytes
    func hexadecimalString(data:NSData) -> String {
        var string = NSMutableString(capacity: data.length * 2)
        var byte: UInt8 = 0
        
        for i in 0 ..< data.length {
            data.getBytes(&byte, range: NSMakeRange(i, 1))
            string.appendFormat("%02x", byte)
        }
        
        return string as String
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // BITCOIN TEST
        /*let seedString:NSString = "b221d9dbb083a7f33428d7c2a3c3198a"
        let seed:NSData = seedString.hexToData()
        //fkey.address = "b221d9dbb083a7f33428d7c2a3c3198ae925614d70210e28716cca0000000000"
        
        
        var bt:BTBIP32Key = BTBIP32Key(secret: seed, andPubKey: nil, andChain: nil, andPath: nil)
        //[[BTBIP32Key alloc] initWithSecret:secret andPubKey:nil andChain:chain andPath:path];
        //println(BTBIP39.sharedInstance().getWords())
        let data:NSData = BTBIP39.sharedInstance().decodePhrase("buy bid grade held cool survive ceiling knock milk over yeah relax")
        var bt2:BTBIP32Key = BTBIP32Key(secret: data, andPubKey: nil, andChain: nil, andPath: nil)
        */
        
        // Setting the settings
        AppManager.sharedInstance.debugMode = false;
        
        
        // UI settings
        // removing navigation bar separator and shadow
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        
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
            self.showMenu(false)
        }
        
        // SIGNING TEST
        /*
        let seedString:NSString = "b221d9dbb083a7f33428d7c2a3c3198ae925614d70210e28716cca0000000000"
        let seed:NSData = seedString.hexToData()
        var bt:BTBIP32Key = BTBIP32Key(secret: seed, andPubKey: nil, andChain: nil, andPath: nil)
        
        var hash:NSString = bt.pubKey.description
        hash = hash.stringByReplacingOccurrencesOfString(" ", withString: "")
        hash = hash.stringByReplacingOccurrencesOfString("<", withString: "")
        hash = hash.stringByReplacingOccurrencesOfString(">", withString: "")
        
        
        let stringData:String = hexadecimalString(bt.pubKey)
        
        let param:NSDictionary = [
            "source": bt.address
            ,"destination": "1Ko36AjTKYh6EzToLU737Bs2pxCsGReApK"
            ,"quantity": 1500000000
            ,"asset": "BRAZUCA"
            ,"pubkey": hash
        ]
        
        PFCloud.callFunctionInBackground("send", withParameters: param as [NSObject : AnyObject]) { (results, error) -> Void in
            if((error) != nil) {
                println("error on getBalances - ", error!.description)
            }else{
                println(results)
                
                let data:NSString = results!["result"] as! NSString
                var trans = BTTx(message: data.hexToData())
                trans.signWithPrivateKeys([bt.key.privateKey])
                
                //let dataSigned = bt.key.sign(data.hexToData())
                println(trans.verifySignatures())
                
                println(self.hexadecimalString(trans.toData()))
                //completion(results: results, error: error)
            }
        }
        */
        
        
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

