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
        
        //AppManager.sharedInstance.userLocalData = UserLocalData(parseId: "")
        //AppManager.sharedInstance.userLocalData!.generatePrivateAddress()
        
        /* cache code
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:firstName forKey:@"firstName"];
        [defaults setObject:lastName forKey:@"lastname"];
        [defaults setInteger:age forKey:@"age"];
        [defaults setObject:imageData forKey:@"image"];
        
        [defaults synchronize];
        */
        
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
        
        // SIGNING TEST (SCRAPPED)
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
        
        
        // Bitcoin transaction. The real deal!
        //AppManager.sharedInstance.userLocalData = UserLocalData(parseId: "")
        //AppManager.sharedInstance.userLocalData!.generatePrivateAddress()
      
        /*var data:NSString = "01000000013d1752950d03bc3438d10c3faaeddcf27d642dbadb26d8efc2c18d0857612d0d000000009200004730440220403fcb0dfadba8b66be1ef3fdbbfe56db0e76b8657cf2febbe659a9a42776f6802206b79399db9b1932e8a13c99e656f736fd253b3fbcfecfbb873f370b9dcadba78014752210213cc3e8aa13da9fdced6ac55737984b71a0ea6a9c1817cc15f687163813e44c82103d4e7ffa6ebedc601a5e9ca48b9d9110bef80c15ce45039a08a513801712579de52aeffffffff01e8030000000000001976a9149ea84056a5a9e294d93f11300be51d51868da69388ac00000000"
        var btx = BRTransaction(message: data.hexToData())
        
        btx.signWithPrivateKeys([AppManager.sharedInstance.userLocalData!.bt!.key.privateKey])
        */
        /*
        let value = 1
        var error: NSError?
        let pub:NSString = "967f947b7f995d7f45c4ce1f6eb42baf58376d8f9ba768322d2abe858f3bd272"
        var hex:NSString = "01000000013d1752950d03bc3438d10c3faaeddcf27d642dbadb26d8efc2c18d0857612d0d0000000000ffffffff01e8030000000000001976a9149ea84056a5a9e294d93f11300be51d51868da69388ac00000000"
        /*let btx:BTTx = BTTxBuilder.instance().buildTxWithOutputs(["14pkzzJbAg1N3EFkEnc4o5uHQJAzCqUUFJ"] as [AnyObject]
            , toAddresses: ["AWXoDzdqqSbf3Fo7yKozXX2aP9nvmsVse"] as [AnyObject]
            , amounts: [0]
            , changeAddress: "14pkzzJbAg1N3EFkEnc4o5uHQJAzCqUUFJ"
            , andError: &error)
        *//*let btx = BTTxBuilder.instance().buildTxForAddress("14pkzzJbAg1N3EFkEnc4o5uHQJAzCqUUFJ"
            , andScriptPubKey: pub.hexToData()
            , andAmount: [value] as [AnyObject]
            , andAddress: ["1FTuKcjGUrMWatFyt8i1RbmRzkY2V9TDMG"] as [AnyObject]
            , andError: &error)
        */
        let btx = BTTx(message: hex.hexToData())
        btx.verifySignatures()*/
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

